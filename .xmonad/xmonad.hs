import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.Submap
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseGestures
import XMonad.Config.Gnome
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
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.WorkspaceCompare --(getSortByXineramaRule, getSortByTag, getSortByIndex)
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
    

myFocusedBorderColor = "#699DD1" --  "#4d7399"-- "#b5480f" -- "#81a2be" -- "#857a66" -- "#476173" -- "#839cad" -- "#A9CDC7" -- "#CD00CD" --magenta
myNormalBorderColor = "#2d2d2d" -- "#1d1f21" -- "#40464b"-- "#3A3A3A"-- "gray"
myBorderWidth = 5 -- pixels

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

                  
myConf nScreens = defaultConfig
		{ modMask = mod3Mask
                , borderWidth = myBorderWidth
		, manageHook = newManageHook
		, focusedBorderColor = myFocusedBorderColor
		, normalBorderColor = myNormalBorderColor
		, layoutHook = myLayout
		, handleEventHook = fullscreenEventHook
		, workspaces = workspaceNames -- [workspaceNames, withScreens nScreens workspaceNames] !! (screenNum - 1)
                               
		, terminal = "xfce4-terminal -e zsh" -- "gnome-terminal -e fish"
		, startupHook = startupHook desktopConfig >> setWMName "LG3D"
		}
  where (S screenNum) = nScreens



screenNames = [">", "<"]

-- prettyName s    -- | name /= "" = (replicate id '&') ++ name
-- 	| name /= "" = name
-- 	| otherwise = show id
-- 	where (S id, name) = unmarshall s

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

-- customPP :: Int -> PP
-- customPP nScreens = xmobarPP {
--            -- ppCurrent = xmobarColor "#e5e8e6" "" . wrap "[" "]" . prettyName
--            ppCurrent = xmobarColor "#c84c00" "" . formatAll
-- 	 , ppLayout = xmobarColor "#F0E68C" "" . shorten 20
-- 	 , ppSep =  "   " -- "<fc=#AFAF87> :: </fc>"
--          , ppWsSep = ""
-- 	 , ppHiddenNoWindows = xmobarColor "#434343" "" . format
-- 	 , ppHidden = formatAll
-- 	 -- , ppVisible = wrap "(" ")" . prettyName
-- 	 , ppVisible = xmobarColor "#e5a59c" "" . formatAll
-- 	 -- , ppUrgent = xmobarColor "#ff0000" "" . wrap "!" "!" . xmobarStrip -- this has not occured in 4+ years of xmonad usage
-- 	 , ppSort = mySort --getSortByTag
-- 	 , ppTitle =  ((replicate 5 ' ') ++) . shorten (nScreens * 30 + 70) . cleanUp . xmobarStrip -- xmobarColor "#00ff74" "" . cleanUp -- . shorten (screenNum * 75)
-- 	 }
--       where format = prettyNameN nScreens
--             formatAll = if (nScreens == 1) then id else format

customPP :: Int -> PP
customPP nScreens = xmobarPP {
           -- ppCurrent = xmobarColor "#e5e8e6" "" . wrap "[" "]" . prettyName
           ppCurrent = const ""
	 , ppLayout = const "" -- ("  " ++) . xmobarColor "#F0E68C" "" . shorten 20
	 , ppSep =  "" -- "<fc=#AFAF87> :: </fc>"
         , ppWsSep = ""
	 , ppHiddenNoWindows = const ""
	 , ppHidden = const ""
	 -- , ppVisible = wrap "(" ")" . prettyName
	 , ppVisible = const ""
	 -- , ppUrgent = xmobarColor "#ff0000" "" . wrap "!" "!" . xmobarStrip -- this has not occured in 4+ years of xmonad usage
	 , ppSort = mySort --getSortByTag
	 , ppTitle =  (" " ++) . shorten (nScreens * 30 + 60) . cleanUp . xmobarStrip -- xmobarColor "#00ff74" "" . cleanUp -- . shorten (screenNum * 75)
	 }
      where format = prettyNameN nScreens
            formatAll = id -- if (nScreens == 1) then id else format

customPP2 :: Int -> PP
customPP2 nScreens = xmobarPP {
           -- ppCurrent = xmobarColor "#e5e8e6" "" . wrap "[" "]" . prettyName
           ppCurrent = xmobarColor "#c84c00" "" . formatAll -- #c84c00 -- #5294e2
	 , ppLayout = const ""
	 , ppSep =  "" -- "<fc=#AFAF87> :: </fc>"
         , ppWsSep = if nScreens == 1 then "  " else "   "
	 , ppHiddenNoWindows = xmobarColor "#606060" "" . formatAll
	 , ppHidden = formatAll
	 -- , ppVisible = wrap "(" ")" . prettyName
	 , ppVisible = xmobarColor "#e5a59c" "" . formatAll -- #e5a59c -- a9abb8
	 -- , ppUrgent = xmobarColor "#ff0000" "" . wrap "!" "!" . xmobarStrip -- this has not occured in 4+ years of xmonad usage
	 , ppSort = mySort --getSortByTag
	 , ppTitle =  const ""
	 }
      where format = prettyNameN nScreens
            formatAll = id -- if (nScreens == 1) then id else format            

cleanUp = filter (not . (`elem` "{}"))


main = do
     nScreens <- countScreens
     let (S screenNum) = nScreens
     spawn "bash ~/scripts/reset_empty_pipe.sh"
     -- xmproc <- spawnPipe $ printf "xmobar ~/.xmonad/xmobar/xmobarrc_%d" screenNum
     xmproc <- spawnPipe $ printf "xmobar ~/.xmonad/xmobar/xmobarrc_%d" screenNum
     -- titleproc <- spawnPipe "rm -f /tmp/xmonad.title && mkfifo /tmp/xmonad.title && cat > /tmp/xmonad.title"
     -- wsproc <- spawnPipe "rm -f /tmp/xmonad.ws && mkfifo /tmp/xmonad.ws && cat > /tmp/xmonad.ws"
     let conf = ewmh $ (myConf nScreens) {
                  logHook =
                      -- dynamicLogWithPP (customPP screenNum) {ppTitle = const "", ppOutput = hPutStrLn xmproc } >>
                      -- dynamicLogWithPP (customPP screenNum) >>
                      -- dynamicLogWithPP (customPP screenNum) {ppOutput = hPutStrLn titleproc} >>
                      dynamicLogWithPP (customPP2 screenNum) {ppOutput = hPutStrLn xmproc}
                }
     xmonad $ fullscreenFix $
       conf { startupHook = startupHook conf >> setWMName "LG3D"}
            `additionalKeys` (myKeys conf screenNum)
--            `additionalKeys` ratingKeys
            `additionalKeys` extraKeys
            `additionalKeysP` myKeysP
            `additionalMouseBindings` myMouseBindings





