module Bindings where

import XMonad
import XMonad.Actions.CycleWS
-- import XMonad.Layout.BinarySpacePartition hiding (Swap)
-- import qualified XMonad.Layout.BinarySpacePartition as BSP
-- import XMonad.Layout.IndependentScreens
import XMonad.Layout.ResizableTile
import XMonad.Hooks.ManageDocks
-- import XMonad.Util.WorkspaceCompare
-- import XMonad.Operations

-- import qualified Data.Map        as M
import qualified XMonad.StackSet as W

-- import Text.Printf (printf)    
import System.Exit

import XMonad.Actions.WindowGo

import Utils

modm = mod3Mask

myKeysP conf =
  [ ("M-S-<Backspace>", spawn "xmonad --recompile; xmonad --restart")
  , ("M-<Backspace>", spawn "xmonad --restart")
  -- , ("M-S-<Space>", sendMessage FirstLayout)
  -- , ("M-<Space>", sendMessage NextLayout)
  , ("M-<Return>", windows W.swapMaster)
  , forEmacs ("M-S-<Return>", spawn $ XMonad.terminal conf)
    --, ("M-i", notiSpawn "Google Chrome" "google-chrome")
  -- , ("M-i", spawn "firefox-aurora")
  -- , ("M-S-i", spawn "chromium")
  , ("M-i", runOrRaise "firefox" (className =? "Firefox"))
  , ("M-S-i", spawn "conkeror")
  , forEmacs ("M-e", spawn editor)
  , ("M-C-e", spawn "emacs")
  , ("M-S-e", spawn "killall emacs; emacs --daemon; emacsclient -c")

  -- , ("M-r", spawn "anki")
  -- , ("M-r", getFocusedTitle)
  -- , forEmacs ("M-r", spawn "notify-send test")
    
  , ("M-j", spawnEdit journalFile)
  , ("M-g", spawnEdit notesFile)
  --, ("M-o", notiSpawn "Xournal" "xournal")
  --, ("M-d", spawn "xjump")
  , ("M-S-a", sendMessage MirrorShrink)
  , ("M-S-u", sendMessage MirrorExpand)
  , ("M-a", sendMessage Shrink)
  , ("M-u", sendMessage Expand)
  -- , ("M-f", sendMessage ToggleStruts)
  , ("M-C-l", spawn "slimlock") -- "xlock -echokeys -echokey '*'"
--  , ("M-s", spawn "xscreensaver-command -lock && systemctl suspend")  -- "xlock -startCmd 'sudo pm-suspend' -mode blank -echokeys -echokey '*'"
  , ("M-S-C-s", spawn "systemctl suspend")
--  , ("M-S-o", shiftNextScreen)
--  , ("M-o", nextScreen)
  , ("M-y", swapNextScreen)
  , ("M-h", windows W.focusDown)
  , ("M-t", windows W.focusUp)
  , ("M-S-h", windows W.swapDown)
  , ("M-S-t", windows W.swapUp)

  -- , ("M-v", moveWS Prev)
  -- , ("M-z", moveWS Next)
  , ("M-z", spawn "zotero")
  
  
  , ("M-n", withFocused $ windows . W.sink)
    --  , ("M-r", spawn "rhythmbox-client")
  --  , ("M-S-t", spawn "bash ~/scripts/trackpad-toggle.sh")
  , ("M-p", spawn "bash ~/scripts/pick_program.sh")
    --, ("M-p", spawn "gmrun")
    --  , ("M-m", appendFilePrompt myXPConfig "/home/pierre/Dropbox/time_log.txt")
  , ("M-S-p", spawn "bash ~/scripts/pick_music.sh")
  -- , ("M-r", spawn "bash ~/scripts/pick_radio.sh")
  , ("M-S-r", spawn "bash ~/scripts/pick_password.sh")
  , ("M-c", spawn "bash ~/scripts/pick_google_music.sh")
  , ("M-S-c", spawn "bash ~/scripts/pick_google_music_title.sh")
  -- , ("M-S-m", spawn "geary")
 
  -- , ("M-S-m", spawn "xfce4-terminal -e 'env TERM=xterm-256color mutt'")
  --  , ("M-f", appendFilePrompt myXPConfig "/home/pierre/Dropbox/NOTES")
  --  , ("M-f", appendMusicFile)
  , ("M-S-w", notiSpawn "Windows XP" "virtualbox --startvm XP")
  -- , ("M-S-w", spawn "notify-send \"$(bash ~/scripts/weather.sh)\"")
  , ("M-q", kill)
  , ("M-S-C-q", io (exitWith ExitSuccess))
--  , ("M-/", changeScreenNum 50) --left screen
--  , ("M-@", changeScreenNum 51) --two screens
--  , ("M-\\", changeScreenNum 52) -- right screen
  -- , ("M-k", spawn "evince ~/Dropbox/reading/current.pdf")

    --left screen
  , ("M-/", spawn "xrandr --output DP1 --off --auto --output eDP1 --primary --auto; killall trayer; xmonad --restart; bash ~/scripts/twoScreenStuff.sh;")
  -- , ("M-C-/", spawn "xrandr --output DP-0 --off; xrandr --output LVDS-0 --primary --auto --panning 1280x800; killall trayer; bash ~/scripts/twoScreenStuff.sh; xmonad --restart;")
    --both screens
  , ("M-=", spawn "xrandr --output DP1 --primary --auto --right-of eDP1 --scale 2x2 --panning 3840x2160+2560+0 --auto; xmonad --restart; xinput set-prop \"UC-LOGIC TWA60 Pen\" --type=float \"Coordinate Transformation Matrix\" 0.4 0 0 0 0.625 0 0 0 1; bash ~/scripts/twoScreenStuff.sh;")
  -- , ("M-C-=", spawn "xrandr --output DP1 --primary --auto --right-of eDP1 --scale 1.75x1.75 --panning 3360x1890+2560+0 --auto; xmonad --restart; xinput set-prop \"UC-LOGIC TWA60 Pen\" --type=float \"Coordinate Transformation Matrix\" 0.56757 0 0.43243 0 1 0 0 0 1; bash ~/scripts/twoScreenStuff.sh;")
  , ("M-S-=", spawn "xrandr --output DP1 --primary --auto --right-of eDP1 --scale 1x1 --panning 1920x1080+2560+0 --auto; xmonad --restart; xinput set-prop \"UC-LOGIC TWA60 Pen\" --type=float \"Coordinate Transformation Matrix\" 0.42857 0 0.5714 0 0.675 0 0 0 1; bash ~/scripts/twoScreenStuff.sh;")

  , ("M-C-=", spawn "xrandr --output HDMI2 --auto --right-of eDP1 --scale 2x2 --panning 3840x2160+2560+0 --auto; xmonad --restart; bash ~/scripts/twoScreenStuff.sh")
  , ("M-C-/", spawn "xrandr --output HDMI2 --off --auto; xmonad --restart; bash ~/scripts/twoScreenStuff.sh")
    
  , ("M-\\", spawn "xrandr --output DP1 --scale 2x2 --panning 3840x2160+0+0 --primary --auto --output eDP1 --off; bash ~/scripts/twoScreenStuff.sh; xmonad --restart") 
  , ("M-S-\\", spawn "xrandr --output DP-1 --rotate normal")
  , ("M-C-\\", spawn "xrandr --output HDMI2 --scale 2x2 --panning 3840x2160+0+0 --primary --auto --output eDP1 --off; bash ~/scripts/twoScreenStuff.sh; xmonad --restart") 
    

  -- , ("M-l", spawn "xrandr --output LVDS-0 --off; killall trayer; bash ~/scripts/twoScreenStuff.sh; xmonad --restart;")
  -- , ("M-S-l", spawn "xrandr --output LVDS-0 --auto; xrandr --output DP-1 --right-of LVDS-0 --primary --auto;killall trayer; bash ~/scripts/twoScreenStuff.sh; xmonad --restart;")

  , ("M-]", spawn "bash ~/scripts/changeBackground.sh")
  --, ("M-S-]", spawn "habak -mS '/home/pierre/Pictures/wallpapers/frames/garden_words/'")
  , ("M-S-]", changeVideoBackground)
  -- , ("M-[", changeArtBackground)
  , ("M-S-[", spawn "bash ~/scripts/pokemon_backgrounds.sh")
  , ("M-[", spawn "bash ~/scripts/cool_backgrounds.sh")
  --, ("M-S-[", changePokemonBackground)

  -- , ("M-d", spawn "thunar")
  -- , ("M-d", spawn "xfce4-terminal -e '/usr/bin/touch'") -- for resizing emacs
    
  , ("M-d", withFocused ((flip  tileWindow) (Rectangle 0 0 2560 1500)) >> withFocused (windows . W.sink) )
      
  -- , ("M-c", spawn "mcomix")
  , ("M-v", spawn "bash ~/scripts/take_screenshot.sh")

  
    
    -- , ("<XF86AudioPrev>", spawn "exaile --prev")
    -- , ("<XF86AudioNext>", spawn "exaile --next")
    -- , ("<XF86AudioPlay>", spawn "exaile --play-pause")
    -- , ("M-f", spawn "notify-send  \"`exaile -q | perl -pi -e 's/, /  --  /g'`\"")
  , ("M-S-g", spawn "python ~/scripts/grateful_dead.py")
  -- , ("M-m", spawn "gmpc") 
  -- , ("M-l", spawn "ario") 
  , ("M-l", spawn "cantata") 

  , ("<XF86AudioRaiseVolume>", spawn "amixer -c 1 set Master 1%+; bash ~/scripts/vol_xmobar.sh")
  , ("<XF86AudioLowerVolume>", spawn "amixer -c 1 set Master 1%-; bash ~/scripts/vol_xmobar.sh")

  , ("<XF86AudioMute>", spawn "pactl set-sink-mute 1 toggle || amixer set Master toggle; bash ~/scripts/vol_xmobar.sh")
  -- , ("<F10>", spawn "bash ~/scripts/vol_xmobar.sh")

  , ("<F11>", spawn "amixer -c 1 set Master 1%+; bash ~/scripts/vol_xmobar.sh")
  , ("<F10>", spawn "amixer -c 1 set Master 1%-; bash ~/scripts/vol_xmobar.sh")
  , ("<F12>", spawn "pactl set-sink-mute 1 toggle || amixer set Master toggle; bash ~/scripts/vol_xmobar.sh")

  , ("<XF86MonBrightnessDown>", spawn "xbacklight -inc -2")
  , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc +2")
  
  , ("<XF86AudioPrev>", spawn "python ~/scripts/media.py prev")
  , ("<XF86AudioNext>", spawn "python ~/scripts/media.py next")
  , ("<XF86AudioPlay>", spawn "python ~/scripts/media.py toggle")

  , ("M-<XF86AudioPlay>", spawn "python ~/scripts/media.py get-details > /tmp/xmonad.music")
  , ("M-<XF86AudioNext>", spawn "mpc random")
  , ("M-<XF86AudioPrev>", spawn "mpc repeat")
    
  , ("<F7>", spawn "python ~/scripts/media.py seek-prev && python ~/scripts/media.py get-time > /tmp/xmonad.music")
  , ("<F9>", spawn "python ~/scripts/media.py seek-next && python ~/scripts/media.py get-time > /tmp/xmonad.music")
  , ("<F8>", spawn "python ~/scripts/media.py get-time > /tmp/xmonad.music")


  , ("<F3>", spawn "python ~/scripts/media.py pause")
  , ("<F4>", spawn "python ~/scripts/media.py prev")
  , ("<F5>", spawn "python ~/scripts/media.py next")

  , ("M-<F3>", spawn "python ~/scripts/media.py get-details > /tmp/xmonad.music")
  , ("M-<F4>", spawn "mpc repeat")
  , ("M-<F5>", spawn "mpc random")
    
  , ("S-<F4>", spawn "python ~/scripts/media.py seek-prev && python ~/scripts/media.py get-time > /tmp/xmonad.music")
  , ("S-<F5>", spawn "python ~/scripts/media.py seek-next && python ~/scripts/media.py get-time > /tmp/xmonad.music")
  , ("S-<F3>", spawn "python ~/scripts/media.py get-time > /tmp/xmonad.music")

        -- , ("M-r", spawn "bash ~/scripts/notify_todo.sh")
  -- , ("M-S-r", spawnEdit todoFile)

  -- , ("M-<Tab>", goToSelected defaultGSConfig)

  , ("M-b", spawn "bash ~/scripts/book_menu.sh")
  , ("M-S-b", spawnEdit "~/Dropbox/org/books.org")

  , ("M-C-p", spawn "mpv $(xclip -o)")

  , ("C-S-1", spawn "xmodmap ~/.xmodmap; xkbset r m; notify-send 'put back keybindings'")
  , ("C-S-2", spawn "bash ~/scripts/switchLayouts.sh; notify-send 'switched layout'")

  , ("M-m", spawn "bash ~/scripts/toggle_russian.sh")

  -- , ("M-S-m", spawn "sleep 0.5 && xdotool key --clearmodifiers Hangul_Hanja")
    -- BSP bindings
  -- , ("M-C-u", sendMessage $ ExpandTowards R)
  -- , ("M-C-a", sendMessage $ ExpandTowards L)
  -- , ("M-C-e", sendMessage $ ExpandTowards D)
  -- , ("M-C-o", sendMessage $ ExpandTowards U)
  -- , ("M-C-s", sendMessage $ ShrinkFrom R)
  -- , ("M-C-h", sendMessage $ ShrinkFrom L)
  -- , ("M-C-n", sendMessage $ ShrinkFrom D)
  -- , ("M-C-t", sendMessage $ ShrinkFrom U)
  -- , ("M-r",    sendMessage $ BSP.Swap)
  -- , ("M-C-r", sendMessage $ Rotate)
  -- , ("M-C-<Left>", sendMessage $ MoveSplit L)
  -- , ("M-C-<Right>", sendMessage $ MoveSplit R)
  -- , ("M-C-<Down>", sendMessage $ MoveSplit D)
  -- , ("M-C-<Up>", sendMessage $ MoveSplit U)
 ]

--extraKeys :: [((ButtonMask, KeySym), X ())]
--extraKeys = [((0, xK_Alt_R), spawn "bash ~/scripts/switchLayouts.sh")
            -- , ((0, xK_Super_R), spawn "sleep 0.05 && xdotool click 3; echo click >> /tmp/clicks")
--            ]
-- extraKeys = [
--  ((0 :: ButtonMask, xK_Alt_R), (spawn "sleep 0.1 && xdotool click 3") :: X ())
--             ]
extraKeys = []

dvpUpKeys = [ xK_ampersand, xK_bracketleft, xK_braceleft, xK_braceright
            , xK_parenleft, xK_equal, xK_asterisk, xK_parenright, xK_plus, xK_bracketright ]
normalUpKeys = [xK_1 .. xK_9]

zeroKey = xK_0 -- xK_dollar for dvp
leftMostKey = xK_grave -- idk for dvp

upKeys = normalUpKeys ++ [zeroKey]

myKeys conf 1 = [((m .|. modm, k), sequence_ [windows $ f i, act i])
                   | (i, k) <- zip (XMonad.workspaces conf) upKeys
                   , (f, m, act) <- [ (W.greedyView, 0, \i -> changeWorkspaceBackground i) -- >> redrawWindows)
                                                    , (W.shift, shiftMask, const (return ()) )]]

myKeys conf 2 = [((m .|. modm, k), sequence_ [windows $ f i, act])
                   | (i, k) <- zip (XMonad.workspaces conf) upKeys
                   , (f, m, act) <- [(W.greedyView, 0, return ()) -- redrawWindows)
                                                    ,(W.shift, shiftMask, return ())]]

-- myKeys conf 2 = [((m .|. modm, k), sequence_ [windows $ onCurrentScreen f i, act])
--                    | (i, k) <- zip (workspaces' conf) upKeys
--                    , (f, m, act) <- [(W.greedyView, 0, return ()) -- redrawWindows)
--                                                     ,(W.shift, shiftMask, return ())]]

myMouseBindings = [ -- mod-shift-button1, Set the window to floating mode and resize by dragging
                    ((modm .|. shiftMask, button1),
                     (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)),

                    ((controlMask .|. shiftMask, button1),
                     \w -> (spawn "sleep 0.1 && xdotool click 3") )
                   -- , ( ( shiftMask, button1 ), mouseGesture gestures ) 
                  ]

-- gestures = M.fromList
--            [ ( [ L ], \_ -> moveWS Prev )
--            , ( [ R ], \_ -> moveWS Next )
--            ]

-- gestures = M.fromList []

ratingSymbols = xK_grave : upKeys++[zeroKey]

-- ratingKeys = [((modm, xK_r), submap $ M.fromList sub)]
--    where sub = [((0, chr), notiSpawn ("Rating: "++value) ("exaile --set-rating="++value))
--                | (value, chr) <- zip (map show [0,10..100]) ratingSymbols]




