{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE CApiFFI #-}

module TinyWL.Server.Keybinds where
import Foreign.Ptr
import Foreign.C.Types

data TinyWLServer

foreign import capi "xkbcommon/xkbcommon-keysyms.h value XKB_KEY_Escape" xK_Escape :: CUInt
foreign import capi "xkbcommon/xkbcommon-keysyms.h value XKB_KEY_F1" xK_F1 :: CUInt
foreign import ccall "hs_terminate_display" terminateDisplay :: Ptr TinyWLServer -> CBool
foreign import ccall "hs_cycle_window_next" cycleWindowNext :: Ptr TinyWLServer -> CBool


{-
   * Here we handle compositor keybindings. This is when the compositor is
   * processing keys, rather than passing them on to the client for its own
   * processing.
   *
   * This function assumes Alt is held down.
-}
handleKeybinding :: Ptr TinyWLServer -> CUInt -> CBool
foreign export ccall "handle_keybinding" handleKeybinding :: Ptr TinyWLServer -> CUInt -> CBool
handleKeybinding server key
  | key == xK_Escape = terminateDisplay server
  | key == xK_F1 = cycleWindowNext server
  | otherwise = 0
