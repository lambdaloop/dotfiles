module Bindings where

import XMonad
import XMonad.Actions.CycleWS
import XMonad.Layout.ResizableTile
import XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet as W
import qualified XMonad.Actions.FlexibleResize as Flex
import qualified XMonad.Prompt         as P
import qualified XMonad.Actions.Submap as SM
import qualified XMonad.Actions.Search as S

import Text.Printf (printf)
import System.Exit

import XMonad.Actions.WindowGo
import XMonad.Actions.WindowBringer

import XMonad.Util.NamedWindows (getName)

import Utils

modm = mod3Mask

myWindowTitler ws w = do
  wClass <- runQuery className w
  wName <- runQuery title w
  return $ printf "%s  --  %s [%s]" wClass wName (W.tag ws)


myWindowBringerConfig :: WindowBringerConfig
myWindowBringerConfig = def
  { menuCommand="rofi"
  , menuArgs = ["-dmenu", "-i", "-l", "10",
                "-font", "Noto Sans 21",
                "-p", "window"]
  , windowTitler = myWindowTitler
  }



myKeysP conf =

  {- WINDOW MANAGEMENT -}
  [ ("M-S-<Backspace>", spawn "xmonad --recompile; xmonad --restart")
  , ("M-<Backspace>", spawn "xmonad --restart")
  , ("M-S-'", sendMessage FirstLayout)
  , ("M-'", sendMessage NextLayout)
  , ("M-<Return>", windows W.swapMaster)
  , ("M-S-,", sendMessage (IncMasterN 1))
  , ("M-S-.", sendMessage (IncMasterN (-1)))

  , ("M-<Down>", sendMessage MirrorShrink)
  , ("M-<Up>", sendMessage MirrorExpand)
  , ("M-<Left>", sendMessage Shrink)
  , ("M-<Right>", sendMessage Expand)
  , ("M-y", swapNextScreen)
  , ("M-s", nextScreen)
  , ("M-S-s", shiftNextScreen)
  , ("M-h", windows W.focusDown)
  , ("M-t", windows W.focusUp)
  , ("M-S-h", windows W.swapDown)
  , ("M-S-t", windows W.swapUp)
  
  , ("M-r", sendMessage ToggleStruts)
  -- , ("M-b", sendMessage $ SetStruts [minBound .. maxBound] [])

  -- , ("M-g", gotoMenuConfig myWindowBringerConfig)
  -- , ("M-S-g", bringMenuConfig myWindowBringerConfig)

  , ("M-n", withFocused $ windows . W.sink)
  , ("M-q", kill)
  , ("M-S-C-q", io (exitWith ExitSuccess))

  {- RUNNING PROGRAMS -}
  , ("M-S-<Return>", spawn $ XMonad.terminal conf)
  , ("M-C-S-<Return>", spawn $ "xfce4-terminal")
  , ("M-i", runOrRaise "firefox" (className =? "Firefox"))
  -- , ("M-i", runOrRaise "firefox-dev" (className =? "Firefox Developer Edition"))
  -- , ("M-s", raiseMaybe (spawn "spotify") (className =? "Spotify"))
  , ("M-S-i", spawn "chromium")
  , ("M-e", spawn editor)
  , ("M-C-e", spawn "notify-send 'starting conda emacs'; bash ~/scripts/conda_emacs.sh")
  , ("M-S-e", spawn "killall emacs; emacs --daemon; emacsclient -c")
  , ("M-u", spawn $ "python3 ~/scripts/launch_common.py")
  , ("M-l", spawn "ymuse")
  , ("M-S-l", spawn "gpodder")
  , ("M-C-p", spawn "mpv $(xclip -o)")
  , ("M-C-z", spawn "chromium --audio-buffer-size=1024 $(xclip -o | sed -r 's,/j/,/wc/join/,g')")
  -- , ("M-C-z", spawn "firefox $(xclip -o | sed -r 's,/j/,/wc/join/,g')")
  , ("M-C-r", spawn "xflock4")
  , ("M-C-l", spawn "xflock4")
  , ("M-C-s", spawn "xfce4-session-logout")
  --, forEmacs ("M-b", spawn "emacsclient -c -e '(beeminder-list-goals)'")
  -- , forEmacs ("M-c", spawn "emacsclient -c -e '(org-capture)'")
  -- , ("M-j", spawnEdit journalFile)
  -- , ("M-m", spawn "xfce4-popup-whiskermenu")
  -- , ("M-g", spawnEdit notesFile)

  {- UTILITIES -}
    -- pickers
  , ("M-p", spawn "bash ~/scripts/pick_program.sh")
  , ("M-S-p", spawn "bash ~/scripts/pick_music.sh")
  , ("M-S-r", spawn "passmenu -b -fn 'Noto Sans 20' -l 10")
  -- , ("M-C-i", spawn "nmcli connection up mullvad_us")
  -- , ("M-c", spawn "bash ~/scripts/pick_google_music.sh")
  -- , ("M-S-c", spawn "bash ~/scripts/pick_google_music_title.sh")

    -- backgrounds
  -- , ("M-#", spawn "bash ~/scripts/changeBackground.sh")
  -- , ("M-S-#", changeVideoBackground)
  , ("M-S-#", spawn "bash ~/scripts/pokemon_backgrounds.sh")
  , ("M-#", spawn "bash ~/scripts/cool_backgrounds.sh")

    -- keyboard
  , ("C-S-1", spawn "xmodmap ~/.xmodmap; xkbset r m; xset r rate 200 15; notify-send 'put back keybindings'")
  , ("C-S-2", spawn "bash ~/scripts/switchLayouts.sh; notify-send 'switched layout'")
  , ("C-S-3", spawn "xdotool key Caps_Lock")
  , ("C-S-&", spawn "xmodmap ~/.xmodmap; xkbset r m; xset r rate 200 15; notify-send 'put back keybindings'")
  , ("C-S-[", spawn "bash ~/scripts/switchLayouts.sh; notify-send 'switched layout'")
  , ("C-S-{", spawn "xdotool key Caps_Lock")
  -- , ("<F2>", spawn "bash ~/scripts/toggle_russian.sh")
  -- , ("M-S-m", spawn "sleep 0.5 && xdotool key --clearmodifiers Hangul_Hanja")

    -- misc
  , ("M-v", spawn "bash ~/scripts/take_screenshot.sh")
  , ("M-S-g", spawn "python3 ~/scripts/grateful_dead.py")


  {- SCREEN MANAGEMENT -}

  -- , ("M-/", spawn "xfconf-query -c xsettings -p /Xft/DPI -s 180; xfconf-query -c xfce4-panel -p /panels/panel-0/size -s 45; xfconf-query -c xfce4-panel -p /plugins/plugin-8/icon-size -s 40; xrandr --auto; xmonad --restart;")
  -- , ("M-=", spawn "xfconf-query -c xsettings -p /Xft/DPI -s 100; xfconf-query -c xfce4-panel -p /panels/panel-0/size -s 30; xfconf-query -c xfce4-panel -p /plugins/plugin-8/icon-size -s 30; xrandr --output eDP-1 --off --auto; xmonad --restart")
  -- , ("M-\\", spawn "xfconf-query -c xsettings -p /Xft/DPI -s 90; xfconf-query -c xfce4-panel -p /panels/panel-0/size -s 25; xfconf-query -c xfce4-panel -p /plugins/plugin-8/icon-size -s 25; xrandr --output eDP-1 --off --auto; xmonad --restart")
  , ("C-S-4", spawn "bash ~/scripts/restart_panel.sh")
  
    -- left
  -- , ("M-/", spawn "xrandr --output DP1 --off --auto --output eDP1 --primary --auto --panning 2560x1600; killall trayer; xmonad --restart; bash ~/scripts/twoScreenStuff.sh;")


    -- 2 screens
  -- , ("M-=", spawn "xrandr --output DP1 --primary --auto --right-of eDP1 --scale 2x2 --panning 3840x2160+2560+0 --auto; xmonad --restart; xinput set-prop \"UC-LOGIC TWA60 Pen\" --type=float \"Coordinate Transformation Matrix\" 0.4 0 0 0 0.625 0 0 0 1; bash ~/scripts/twoScreenStuff.sh;")
  -- , ("M-S-=", spawn "xrandr --output DP1 --primary --auto --right-of eDP1 --scale 1x1 --panning 1920x1080+2560+0 --auto; xmonad --restart; xinput set-prop \"UC-LOGIC TWA60 Pen\" --type=float \"Coordinate Transformation Matrix\" 0.42857 0 0.5714 0 0.675 0 0 0 1; bash ~/scripts/twoScreenStuff.sh;")

  -- , ("M-C-=", spawn "xrandr --output HDMI2 --scale 2x2 --panning 3840x2160+0+0 --primary --auto --right-of eDP1; bash ~/scripts/twoScreenStuff.sh; xmonad --restart")
  -- , ("M-C-/", spawn "xrandr --output HDMI2 --off --auto --output eDP1 --primary --auto; killall trayer; xmonad --restart; bash ~/scripts/twoScreenStuff.sh;")

    -- right only
  -- , ("M-\\", spawn "xrandr --output DP1 --scale 1.8x1.8 --panning 4608x2592+0+0 --primary --auto --output eDP1 --off; bash ~/scripts/twoScreenStuff.sh; xmonad --restart")
  -- -- , ("M-S-\\", spawn "xrandr --output HDMI2 --scale 2x2 --panning 5120x2160+0+0 --primary --auto --output eDP1 --off; bash ~/scripts/twoScreenStuff.sh; xmonad --restart")
  -- , ("M-S-\\", spawn "xrandr --output HDMI2 --scale 2x2  --primary --auto --panning 3200x1800+0+0 --output eDP1 --off; basht ~/scripts/twoScreenStuff.sh; xmonad --restart")
  -- , ("M-C-\\", spawn "xrandr --output HDMI2 --scale 2x2 --panning 3840x2160+0+0 --primary --auto --output eDP1 --off; bash ~/scripts/twoScreenStuff.sh; xmonad --restart")
  -- -- , ("M-S-C-\\", spawn "xrandr --output HDMI2 --scale 2x2 --panning 5120x2160+0+0 --primary --auto --output eDP1 --off; bash ~/scripts/twoScreenStuff.sh; xmonad --restart")
  -- , ("M-S-C-\\", spawn "xrandr --output HDMI2 --scale 2x2 --panning 5120x2880+0+0 --primary --auto --output eDP1 --off; bash ~/scripts/twoScreenStuff.sh; xmonad --restart")

  
  , ("<XF86MonBrightnessDown>", spawn "xbacklight -inc -5")
  , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc +5")
  , ("M-<XF86MonBrightnessDown>", spawn "xbacklight -inc -1")
  , ("M-<XF86MonBrightnessUp>", spawn "xbacklight -inc +1")

  , ("<XF86KbdBrightnessDown>", spawn "xbacklight -inc -5")
  , ("<XF86KbdBrightnessUp>", spawn "xbacklight -inc +5")
  , ("M-<XF86KbdBrightnessDown>", spawn "xbacklight -inc -1")
  , ("M-<XF86KbdBrightnessUp>", spawn "xbacklight -inc +1")

  -- , ("<XF86MonBrightnessDown>", spawn "python3 ~/scripts/set_brightness.py dec")
  -- , ("<XF86MonBrightnessUp>", spawn "python3 ~/scripts/set_brightness.py inc")
  -- , ("M-<XF86MonBrightnessDown>", spawn "python3 ~/scripts/set_brightness.py dec 1")
  -- , ("M-<XF86MonBrightnessUp>", spawn "python3 ~/scripts/set_brightness.py inc 1")


  {- AUDIO MANAGEMENT -}
  , ("<XF86AudioRaiseVolume>", spawn "pulseaudio-ctl up 2")
  , ("<XF86AudioLowerVolume>", spawn "pulseaudio-ctl down 2")
  , ("<XF86AudioMute>", spawn "pulseaudio-ctl mute")


  , ("<F6>", spawn "pulseaudio-ctl up 2")
  , ("<F5>", spawn "pulseaudio-ctl down 2")
  , ("<F4>", spawn "pulseaudio-ctl mute")


  , ("<XF86AudioPrev>", spawn "python3 ~/scripts/media.py prev")
  , ("<XF86AudioNext>", spawn "python3 ~/scripts/media.py next")
  , ("<XF86AudioPlay>", spawn "python3 ~/scripts/media.py toggle")

  -- , ("M-<XF86AudioPlay>", spawn "python3 ~/scripts/media.py get-details > /tmp/xmonad.music")
  , ("M-<XF86AudioNext>", spawn "mpc random")
  , ("M-<XF86AudioPrev>", spawn "mpc repeat")
  , ("S-<XF86AudioPrev>", spawn "python3 ~/scripts/media.py seek-prev")
  , ("S-<XF86AudioNext>", spawn "python3 ~/scripts/media.py seek-next")
  -- , ("S-<XF86AudioPlay>", spawn "python3 ~/scripts/media.py get-time > /tmp/xmonad.music")

  -- , ("<F7>", spawn "python3 ~/scripts/media.py seek-prev && python3 ~/scripts/media.py get-time > /tmp/xmonad.music")
  -- , ("<F9>", spawn "python3 ~/scripts/media.py seek-next && python3 ~/scripts/media.py get-time > /tmp/xmonad.music")
  -- , ("<F8>", spawn "python3 ~/scripts/media.py get-time > /tmp/xmonad.music")


  , ("<F1>", spawn "python3 ~/scripts/media.py prev")
  , ("<F2>", spawn "python3 ~/scripts/media.py toggle")
  , ("<F3>", spawn "python3 ~/scripts/media.py next")

  -- , ("M-<F3>", spawn "python3 ~/scripts/media.py get-details > /tmp/xmonad.music")
  -- , ("M-<F4>", spawn "mpc repeat")
  -- , ("M-<F5>", spawn "mpc random")

  , ("S-<F1>", spawn "python3 ~/scripts/media.py seek-prev")
  , ("S-<F3>", spawn "python3 ~/scripts/media.py seek-next")
  -- , ("S-<F3>", spawn "python3 ~/scripts/media.py get-time > /tmp/xmonad.music")
 ]
  -- ++ [("M-s " ++ k, S.promptSearch P.def f) | (k,f) <- searchList ]
  -- ++ [("M-S-s " ++ k, S.selectSearch f) | (k,f) <- searchList ]

searchList :: [(String, S.SearchEngine)]
searchList = [ ("g", S.google)
             , ("h", S.hoogle)
             , ("w", S.wikipedia)
             ]
  
-- extraKeys :: [((ButtonMask, KeySym), X ())]
-- extraKeys = [((0, xK_Alt_R), spawn "bash ~/scripts/switchLayouts.sh")
--             -- , ((0, xK_Super_R), spawn "sleep 0.05 && xdotool click 3; echo click >> /tmp/clicks")
--            ]
--  ((0 :: ButtonMask, xK_Alt_R), (spawn "sleep 0.1 && xdotool click 3") :: X ())
--             ]
extraKeys = []

dvpUpKeys = [ xK_ampersand, xK_bracketleft, xK_braceleft, xK_braceright
            , xK_parenleft, xK_equal, xK_asterisk, xK_parenright, xK_plus, xK_bracketright ]
normalUpKeys = [xK_1 .. xK_9]

zeroKey = xK_0
leftMostKey = xK_grave

upKeys = normalUpKeys ++ [zeroKey]
-- upKeys = dvpUpKeys

myKeys conf 1 = [((m .|. modm, k), sequence_ [windows $ f i, act i])
                   | (i, k) <- zip (XMonad.workspaces conf) upKeys
                   , (f, m, act) <- [ (W.greedyView, 0, \i -> changeWorkspaceBackground i)
                                                    , (W.shift, shiftMask, const (return ()) )]]

myKeys conf 2 = [((m .|. modm, k), sequence_ [windows $ f i, act])
                   | (i, k) <- zip (XMonad.workspaces conf) upKeys
                   , (f, m, act) <- [(W.greedyView, 0, return ())
                                                    ,(W.shift, shiftMask, return ())]]

myMouseBindings = [ -- mod-shift-button1, Set the window to floating mode and resize by dragging
                    ((modm .|. shiftMask, button1),
                     (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)),

                    ((controlMask .|. shiftMask, button1),
                     \w -> (spawn "sleep 0.1 && xdotool click 3") )
                   -- , ( ( shiftMask, button1 ), mouseGesture gestures )
                  ]


ratingSymbols = xK_grave : upKeys++[zeroKey]
