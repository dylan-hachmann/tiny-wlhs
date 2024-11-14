{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE CApiFFI #-}

module TinyWL.Server.FFI where

import Foreign.C.Types
import Foreign.C.String
import Foreign.Ptr
import Foreign.Marshal.Array (newArray)
import TinyWL.Server.Types (TinyWLServer)


foreign import ccall "server_create" c_server_create :: IO (Ptr TinyWLServer)
foreign import ccall "server_destroy" c_server_destroy :: Ptr TinyWLServer -> IO ()
foreign import ccall "server_init" c_server_init :: Ptr TinyWLServer -> IO Bool
foreign import ccall "server_start" c_server_start :: Ptr TinyWLServer -> IO CString
foreign import ccall "server_run" c_server_run :: Ptr TinyWLServer -> IO ()
foreign import ccall "server_set_startup_command" c_server_set_startup_command :: CString -> IO ()


withCArgs :: [String] -> IO (Ptr (Ptr CChar))
withCArgs args = newArray =<< mapM newCString args

{-
   * Here we handle compositor keybindings. This is when the compositor is
   * processing keys, rather than passing them on to the client for its own
   * processing.
   *
   * This function assumes Alt is held down.
-}
foreign import capi "xkbcommon/xkbcommon-keysyms.h value XKB_KEY_Escape" xK_Escape :: CUInt
foreign import capi "xkbcommon/xkbcommon-keysyms.h value XKB_KEY_F1" xK_F1 :: CUInt
foreign import ccall "hs_terminate_display" terminateDisplay :: Ptr TinyWLServer -> CBool
foreign import ccall "hs_cycle_window_next" cycleWindowNext :: Ptr TinyWLServer -> CBool
foreign export ccall "handle_keybinding" handleKeybinding :: Ptr TinyWLServer -> CUInt -> CBool
handleKeybinding server xK_Escape = terminateDisplay server
handleKeybinding server xK_F1 = cycleWindowNext server
handleKeybinding server _ = 0 :: CBool
