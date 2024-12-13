{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE CApiFFI #-}

module TinyWL.Server.Keybinds where
import Foreign.Ptr
import Foreign.C.Types

data TinyWLServer

-- foreign import capi "xkbcommon/xkbcommon-keysyms.h value XKB_KEY_Escape" xK_Escape :: CUInt
-- foreign import capi "xkbcommon/xkbcommon-keysyms.h value XKB_KEY_F1" xK_F1 :: CUInt
foreign import ccall "hs_terminate_display" terminateDisplay :: Ptr TinyWLServer -> CBool
foreign import ccall "hs_cycle_window_next" cycleWindowNext :: Ptr TinyWLServer -> CBool


{-
   * Here we handle compositor keybindings. This is when the compositor is
   * processing keys, rather than passing them on to the client for its own
   * processing.
   *
   * This function assumes Alt is held down.
-}
{-
FIXME: foreign import doesn't seem to be working at the moment; write
out the keysym values directly for now
-}
foreign export ccall "handle_keybinding" handleKeybinding :: Ptr TinyWLServer -> CUInt -> CBool
handleKeybinding server key = case key of
                                0xff1b -> terminateDisplay server
                                0xffbe -> cycleWindowNext server
                                _ -> 0 :: CBool
