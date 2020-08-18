import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.Submap
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseGestures
import XMonad.Actions.UpdatePointer
import XMonad.Config.Kde
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName
import XMonad.ManageHook
import XMonad.Layout.IndependentScreens
import XMonad.Prompt
import XMonad.Prompt.AppendFile
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Util.WorkspaceCompare
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import qualified System.IO

import System.IO (Handle, hPutStrLn)
import Control.Monad (when, liftM)
import Data.List (delete)
import XMonad.Util.WindowProperties (getProp32)
import Data.Monoid
import Data.Maybe (fromMaybe)
import Text.Printf (printf)
import System.Exit

import System.Random
import System.Process

-- custom modules
import Bindings
import Layout
import Utils (replace)

myFocusedBorderColor = "#BD93F9" -- "#d18d86" -- "#699DD1" -- "#664F3D" -- "#F4EBD4"
myNormalBorderColor = "#282A36" -- "#32302f" --"#102235" -- "#F4EBD4"
myBorderWidth = 4 -- pixels

workspaceNames = map show ([1..9] ++ [0])


-- fullscreen fix from https://github.com/mpv-player/mpv/issues/888
fullscreenFix :: XConfig a -> XConfig a
fullscreenFix c = c {
  startupHook = startupHook c +++ setSupportedWithFullscreen
  }
  where x +++ y = mappend x y

setSupportedWithFullscreen :: X ()
setSupportedWithFullscreen = withDisplay $ \dpy -> do
    r <- asks theRoot
    a <- getAtom "_NET_SUPPORTED"
    c <- getAtom "ATOM"
    supp <- mapM getAtom ["_NET_WM_STATE_HIDDEN"
                         ,"_NET_WM_STATE_FULLSCREEN"
                         ,"_NET_NUMBER_OF_DESKTOPS"
                         ,"_NET_CLIENT_LIST"
                         ,"_NET_CLIENT_LIST_STACKING"
                         ,"_NET_CURRENT_DESKTOP"
                         ,"_NET_DESKTOP_NAMES"
                         ,"_NET_ACTIVE_WINDOW"
                         ,"_NET_WM_DESKTOP"
                         ,"_NET_WM_STRUT"
                         ]
    io $ changeProperty32 dpy r a c propModeReplace (fmap fromIntegral supp)


myConf nScreens = kdeConfig
                { modMask = mod3Mask
                , borderWidth = myBorderWidth
                , manageHook = newManageHook
                , focusedBorderColor = myFocusedBorderColor
                , normalBorderColor = myNormalBorderColor
                , layoutHook = myLayout
                , handleEventHook = fullscreenEventHook
                , keys = const (M.fromList [])
                , workspaces = workspaceNames -- [workspaceNames, withScreens nScreens workspaceNames] !! (screenNum - 1)
                -- , terminal = "emacsclient -c -e '(eshell)'"
                -- , terminal = "konsole --hide-menubar"
                -- , terminal = "xfce4-terminal"
                , terminal = "emacsclient -c -e '(progn (vterm-toggle) (delete-other-windows))'"
                , startupHook = startupHook kdeConfig >> setWMName "LG3D"
                }
  where (S screenNum) = nScreens



screenNames = [">", "<"]

prettyNameN n s
    | name /= "" && (n > 1) = name
    | name /= "" = ""
    | otherwise = show id
    where (S id, name) = unmarshall s


sortName s
    | name /= "" = (screenNames !! id) ++ name
    | otherwise = if id == 0 then "99" else (show id)
    where (S id, nameX) = unmarshall s
          name = if nameX == "0" then "99" else nameX -- place 0 after 9 to match keyboard


mySort = mkWsSort (return cmp)
   where cmp a b = compare (sortName a) (sortName b)



customPP :: Int -> PP
customPP nScreens = xmobarPP {
           ppCurrent = xmobarColor "#e67128" "" . formatAll
         , ppLayout = const ""
         , ppSep =  ""
         , ppWsSep = if nScreens == 1 then "  " else "   "
         , ppHiddenNoWindows = xmobarColor "#606060" "" . formatAll
         , ppHidden = formatAll
         , ppVisible = xmobarColor "#e5a59c" "" . formatAll -- #e5a59c -- a9abb8
         -- , ppUrgent = xmobarColor "#ff0000" "" . wrap "!" "!" . xmobarStrip -- this has not occured in 4+ years of xmonad usage
         , ppSort = mySort
         , ppTitle =  const ""
         }
      where format = prettyNameN nScreens
            formatAll = id -- if (nScreens == 1) then id else format

cleanUp = filter (not . (`elem` "{}"))


main = do
     nScreens <- countScreens
     let (S screenNum) = nScreens
     spawn "xmodmap ~/.xmodmap"
     -- spawn "xcompmgr"
     -- spawn "bash ~/scripts/reset_empty_pipe.sh"
     -- xmobarConfig <- liftM (filter (/='\n')) $
     --   runProcessWithInput "/home/pierre/scripts/get_xmobar_config.sh" [] ""
     -- xmproc <- spawnPipe $ printf "xmobar %s" xmobarConfig
     let conf = ewmh $ (myConf nScreens) {
                 logHook = dynamicLogWithPP (customPP screenNum) -- >> updatePointer (0.5, 0.5) (0, 0)
                 -- {ppOutput = hPutStrLn xmproc}
     }
     xmonad $ fullscreenFix $
       conf { startupHook = startupHook conf >> setWMName "LG3D"}
            `additionalKeys` (myKeys conf screenNum)
            `additionalKeys` extraKeys
            `additionalKeysP` (myKeysP conf)
            `additionalMouseBindings` myMouseBindings
