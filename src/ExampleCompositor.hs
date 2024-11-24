module Main where

import qualified TinyWL.Server.FFI as FFI
import qualified TinyWL.Server.Server as Server
import qualified TinyWL.Compositor.Compositor as Compositor
import System.Environment (getArgs, setEnv)
import Foreign.C.String
import Foreign.Ptr
import WLR.Util.Log


main :: IO ()
main = do
    -- Initialize logging
    wlr_log_init WLR_DEBUG nullFunPtr

    -- Add a test log message
    wlr_log WLR_INFO "Initializing TinyWL with wlhs bindings"
    

    args <- getArgs
    server <- FFI.c_server_create
    wlr_log WLR_DEBUG "Server created"

    initSuccess <- FFI.c_server_init server
    if initSuccess
        then do
            wlr_log WLR_INFO "Server initialized successfully"
            wlDisplay <- Server.getWlDisplay server
            renderer <- Server.getRenderer server
            _ <- Compositor.initialize_compositor wlDisplay 5 renderer
            socket <- FFI.c_server_start server
            if socket /= nullPtr
                then do
                    socketStr <- peekCString socket
                    setEnv "WAYLAND_DISPLAY" socketStr
                    wlr_log WLR_INFO $ "WAYLAND_DISPLAY set to " ++ socketStr
                    case args of
                        ("-s":cmd:_) -> do
                            withCString cmd FFI.c_server_set_startup_command
                            wlr_log WLR_DEBUG $ "Startup command set: " ++ cmd
                        _ -> return ()
                    putStrLn $ "Running Wayland compositor on WAYLAND_DISPLAY=" ++ socketStr
                    FFI.c_server_run server
                else wlr_log WLR_ERROR "Failed to start server"
        else wlr_log WLR_ERROR "Failed to initialize server"
    FFI.c_server_destroy server
    wlr_log WLR_INFO "Server destroyed, shutting down"
