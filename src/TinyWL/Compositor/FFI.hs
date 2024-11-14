{-# LANGUAGE ForeignFunctionInterface #-}

module TinyWL.Compositor.FFI where

import Foreign.C.Types
import Foreign.C.String
import Foreign.Ptr
import Foreign.Marshal.Array (newArray)
import WLR.Render.Renderer (WLR_renderer)
import TinyWL.Server.Types(TinyWLServer)
import TinyWL.Compositor.Types

-- This should be in wlhs and not here
foreign import ccall "wlr_compositor_create" c_wlr_compositor_create :: Ptr WlDisplay -> CUInt -> Ptr WLR_renderer -> IO (Ptr WlrCompositor)
foreign import ccall "wlr_subcompositor_create" c_wlr_subcompositor_create :: Ptr WlDisplay -> IO (Ptr WlrSubCompositor)
foreign import ccall "wlr_data_device_manager_create" c_wlr_data_device_manager_create :: Ptr WlDisplay -> IO(Ptr WlrDataDeviceManager)




