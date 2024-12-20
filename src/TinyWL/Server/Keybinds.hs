{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE CApiFFI #-}

module TinyWL.Server.Keybinds where
import Foreign.Ptr
import Foreign.C.Types
import Data.Bits ((.|.))

data TinyWLServer

type Key = CUInt
type Server = Ptr TinyWLServer
type Action = Server -> IO CBool

foreign import capi "xkbcommon/xkbcommon-keysyms.h value XKB_KEY_Escape" xK_Escape :: Key
foreign import capi "xkbcommon/xkbcommon-keysyms.h value XKB_KEY_F1" xK_F1 :: Key
foreign import ccall "hs_terminate_display" terminateDisplay :: Action
foreign import ccall "hs_cycle_window_next" cycleWindowNext :: Action


{-
   * Here we handle compositor keybindings. This is when the compositor is
   * processing keys, rather than passing them on to the client for its own
   * processing.
   *
   * This function assumes Alt is held down.
-}
handleKeybinding :: Server -> Key -> IO CBool
foreign export ccall "handle_keybinding" handleKeybinding :: Ptr TinyWLServer -> Key -> IO CBool
handleKeybinding server key = foldr tryAllKeybinds cFalse keybinds
  where tryAllKeybinds bind x = liftA2 (.|.) x $ tryKeybind server key bind
        cFalse = pure (CBool 0) :: IO CBool

tryKeybind :: Server -> Key -> (Key, Action) -> IO CBool
tryKeybind server pressedKey (matchKey, action) =
  if pressedKey == matchKey then action server else pure 0

keybinds :: [(Key, Action)]
keybinds =
  [ (xK_Escape, terminateDisplay)
  , (xK_F1, cycleWindowNext)
  ]
