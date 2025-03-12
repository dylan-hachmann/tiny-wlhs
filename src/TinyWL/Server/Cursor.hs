{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE CApiFFI #-}

module TinyWL.Server.Cursor where
import Foreign.Ptr
import Foreign.C.Types
import Foreign

data TinyWLServer
data TinyWLToplevel
data WLRCursor
data WLRSceneNode
data WLRSceneTree

type Server = Ptr TinyWLServer
type Toplevel = Ptr TinyWLToplevel
type Cursor = Ptr WLRCursor
type Node = Ptr WLRSceneNode
type Tree = Ptr WLRSceneTree

foreign import ccall "hs_get_grabbed_toplevel" getGrabbedToplevel :: Server -> Toplevel
foreign import ccall "hs_get_scene_tree" getSceneTree :: Toplevel -> Tree
foreign import ccall "hs_get_node_ptr" getNode :: Tree -> Node
foreign import ccall "hs_get_cursor" getCursor :: Server -> Cursor
foreign import ccall "hs_get_x_from_cursor" getXFromCursor :: Cursor -> CDouble
foreign import ccall "hs_get_y_from_cursor" getYFromCursor :: Cursor -> CDouble
foreign import ccall "hs_get_grab_x" getGrabX :: Server -> CDouble
foreign import ccall "hs_get_grab_y" getGrabY :: Server -> CDouble
foreign import ccall "hs_double_to_int" doubleToInt :: CDouble -> CInt


-- todo: move this into proper wlhs bindings
foreign import ccall "wlr_scene_node_set_position" wlrSceneNodeSetPosition :: Node -> CInt -> CInt -> IO ()


processCursorMove :: Server -> Word -> IO ()
foreign export ccall "process_cursor_move" processCursorMove :: Server -> Word -> IO ()
processCursorMove server _ =
  let node = getNode $ getSceneTree $ getGrabbedToplevel server
      cursor = getCursor server
      x = doubleToInt $ (getXFromCursor cursor) - (getGrabX server)
      y = doubleToInt $ (getYFromCursor cursor) - (getGrabY server)
  in wlrSceneNodeSetPosition node x y
