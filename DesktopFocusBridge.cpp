#include <inspectable.h>
#include <objbase.h>
#include <servprov.h>
#include <windows.h>

#if !defined(_WIN64)
#error DesktopFocusBridge must be built for x64 to match VirtualDesktopAccessor.dll.
#endif

// These Shell interfaces are undocumented and can change between Windows builds.
struct __declspec(uuid("372E1D3B-38D3-42E4-A15B-8AB2B178F513"))
IApplicationViewInternal : IInspectable {
    virtual HRESULT STDMETHODCALLTYPE SetFocus() = 0;
    virtual HRESULT STDMETHODCALLTYPE SwitchTo() = 0;
};

struct __declspec(uuid("1841C6D7-4F9D-42C0-AF41-8747538F10E5"))
IApplicationViewCollectionInternal : IUnknown {
    virtual HRESULT STDMETHODCALLTYPE GetViews(void** views) = 0;
    virtual HRESULT STDMETHODCALLTYPE GetViewsByZOrder(void** views) = 0;
    virtual HRESULT STDMETHODCALLTYPE GetViewsByAppUserModelId(
        PCWSTR appUserModelId, void** views) = 0;
    virtual HRESULT STDMETHODCALLTYPE GetViewForHwnd(
        HWND window, IApplicationViewInternal** view) = 0;
};

static const CLSID CLSID_ImmersiveShell = {
    0xC2F03A33,
    0x21F5,
    0x47FA,
    {0xB4, 0xBB, 0x15, 0x63, 0x62, 0xA2, 0xF2, 0x39},
};

struct PreparedFocus {
    IServiceProvider* provider = nullptr;
    IApplicationViewCollectionInternal* collection = nullptr;
    IApplicationViewInternal* view = nullptr;
    bool uninitializeCom = false;
};

static thread_local PreparedFocus prepared;

static void ReleasePreparedFocus() {
    if (prepared.view)
        prepared.view->Release();
    if (prepared.collection)
        prepared.collection->Release();
    if (prepared.provider)
        prepared.provider->Release();
    if (prepared.uninitializeCom)
        CoUninitialize();
    prepared = {};
}

extern "C" __declspec(dllexport) HRESULT WINAPI PrepareWindowFocus(HWND window) {
    ReleasePreparedFocus();
    if (!window || !IsWindow(window))
        return E_INVALIDARG;

    HRESULT result = CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);
    if (SUCCEEDED(result))
        prepared.uninitializeCom = true;
    else if (result != RPC_E_CHANGED_MODE)
        return result;

    result = CoCreateInstance(CLSID_ImmersiveShell, nullptr, CLSCTX_LOCAL_SERVER,
        IID_PPV_ARGS(&prepared.provider));
    if (SUCCEEDED(result)) {
        result = prepared.provider->QueryService(
            __uuidof(IApplicationViewCollectionInternal),
            __uuidof(IApplicationViewCollectionInternal),
            reinterpret_cast<void**>(&prepared.collection));
    }
    if (SUCCEEDED(result))
        result = prepared.collection->GetViewForHwnd(window, &prepared.view);
    if (SUCCEEDED(result))
        result = CoAllowSetForegroundWindow(prepared.provider, nullptr);

    if (FAILED(result))
        ReleasePreparedFocus();
    return result;
}

extern "C" __declspec(dllexport) HRESULT WINAPI CommitWindowFocus() {
    if (!prepared.view)
        return E_UNEXPECTED;

    const HRESULT result = prepared.view->SetFocus();
    ReleasePreparedFocus();
    return result;
}

extern "C" __declspec(dllexport) void WINAPI CancelWindowFocus() {
    ReleasePreparedFocus();
}
