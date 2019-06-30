module Bindings where

import XMonad
import XMonad.Actions.CycleWS
import XMonad.Layout.ResizableTile
import XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet as W

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

  , ("M-S-<Down>", sendMessage MirrorShrink)
  , ("M-S-<Up>", sendMessage MirrorExpand)
  , ("M-S-<Left>", sendMessage Shrink)
  , ("M-S-<Right>", sendMessage Expand)
  , ("M-C-l", spawn "slimlock")
  , ("M-y", swapNextScreen)
  , ("M-h", windows W.focusDown)
  , ("M-t", windows W.focusUp)
  , ("M-S-h", windows W.swapDown)
  , ("M-S-t", windows W.swapUp)

  , ("M-r", sendMessage ToggleStruts)
  , ("M-b", sendMessage $ SetStruts [minBound .. maxBound] [])

  , ("M-g", gotoMenuConfig myWindowBringerConfig)
  , ("M-S-g", bringMenuConfig myWindowBringerConfig)

  , ("M-n", withFocused $ windows . W.sink)
  , ("M-q", kill)
  , ("M-S-C-q", io (exitWith ExitSuccess))

  {- RUNNING PROGRAMS -}
  , ("M-S-<Return>", spawn $ XMonad.terminal conf)
  , ("M-i", runOrRaise "firefox" (className =? "Firefox"))
  , ("M-s", raiseMaybe (spawn "spotify --force-device-scale-factor=2") (className =? "Spotify"))
  , ("M-S-i", spawn "conkeror")
  , ("M-e", spawn editor)
  , ("M-C-e", spawn "notify-send 'starting conda emacs'; bash ~/scripts/conda_emacs.sh")
  , ("M-S-e", spawn "killall emacs; emacs --daemon; emacsclient -c")
  , ("M-u", spawn $ "python ~/scripts/launch_common.py")
  , ("M-l", spawn "cantata")
  , ("M-C-p", spawn "mpv $(xclip -o)")
  --, forEmacs ("M-b", spawn "emacsclient -c -e '(beeminder-list-goals)'")
  , forEmacs ("M-c", spawn "emacsclient -c -e '(org-capture)'")
  -- , ("M-j", Spawnedit journalFile)
  -- , ("M-g", spawnEdit notesFile)

  {- UTILITIES -}
    -- pickers
  , ("M-p", spawn "bash ~/scripts/pick_program.sh")
  , ("M-S-p", spawn "bash ~/scripts/pick_music.sh")
  , ("M-S-r", spawn "passmenu -b -fn 'Noto Sans 20' -l 10")
  , ("M-C-i", spawn "nmcli connection up mullvad_us")
  -- , ("M-c", spawn "bash ~/scripts/pick_google_music.sh")
  -- , ("M-S-c", spawn "bash ~/scripts/pick_google_music_title.sh")

    -- backgrounds
  , ("M-]", spawn "bash ~/scripts/changeBackground.sh")
  , ("M-S-]", changeVideoBackground)
  , ("M-S-[", spawn "bash ~/scripts/pokemon_backgrounds.sh")
  , ("M-[", spawn "bash ~/scripts/cool_backgrounds.sh")

    -- keyboard
  , ("C-S-1", spawn "xmodmap ~/.xmodmap; xkbset r m; xset r rate 200 15; notify-send 'put back keybindings'")
  , ("C-S-2", spawn "bash ~/scripts/switchLayouts.sh; notify-send 'switched layout'")
  , ("<F2>", spawn "bash ~/scripts/toggle_russian.sh")
  -- , ("M-S-m", spawn "sleep 0.5 && xdotool key --clearmodifiers Hangul_Hanja")

    -- misc
  , ("M-v", spawn "bash ~/scripts/take_screenshot.sh")
  -- , ("M-S-g", spawn "python ~/scripts/grateful_dead.py")


  {- SCREEN MANAGEMENT -}

    -- left
  , ("M-/", spawn "xrandr --output DP1 --off --auto --output eDP1 --primary --auto --panning 2560x1600; killall trayer; xmonad --restart; bash ~/scripts/twoScreenStuff.sh;")


    -- 2 screens
  , ("M-=", spawn "xrandr --output DP1 --primary --auto --right-of eDP1 --scale 2x2 --panning 3840x2160+2560+0 --auto; xmonad --restart; xinput set-prop \"UC-LOGIC TWA60 Pen\" --type=float \"Coordinate Transformation Matrix\" 0.4 0 0 0 0.625 0 0 0 1; bash ~/scripts/twoScreenStuff.sh;")
  , ("M-S-=", spawn "xrandr --output DP1 --primary --auto --right-of eDP1 --scale 1x1 --panning 1920x1080+2560+0 --auto; xmonad --restart; xinput set-prop \"UC-LOGIC TWA60 Pen\" --type=float \"Coordinate Transformation Matrix\" 0.42857 0 0.5714 0 0.675 0 0 0 1; bash ~/scripts/twoScreenStuff.sh;")

  , ("M-C-=", spawn "xrandr --output HDMI2 --auto --right-of eDP1 --scale 2x2 --panning 3840x2160+2560+0 --auto; xmonad --restart; bash ~/scripts/twoScreenStuff.sh")
  , ("M-C-/", spawn "xrandr --output HDMI2 --off --auto --output eDP1 --primary --auto; killall trayer; xmonad --restart; bash ~/scripts/twoScreenStuff.sh;")

    -- right only
  , ("M-\\", spawn "xrandr --output DP1 --scale 1.8x1.8 --panning 4608x2592+0+0 --primary --auto --output eDP1 --off; bash ~/scripts/twoScreenStuff.sh; xmonad --restart")
  -- , ("M-S-\\", spawn "xrandr --output HDMI2 --scale 2x2 --panning 5120x2160+0+0 --primary --auto --output eDP1 --off; bash ~/scripts/twoScreenStuff.sh; xmonad --restart")
  , ("M-S-\\", spawn "xrandr --output HDMI2 --scale 2x2  --primary --auto --panning 3200x1800+0+0 --output eDP1 --off; bash ~/scripts/twoScreenStuff.sh; xmonad --restart")
  , ("M-C-\\", spawn "xrandr --output HDMI2 --scale 2x2 --panning 3840x2160+0+0 --primary --auto --output eDP1 --off; bash ~/scripts/twoScreenStuff.sh; xmonad --restart")
  -- , ("M-S-C-\\", spawn "xrandr --output HDMI2 --scale 2x2 --panning 5120x2160+0+0 --primary --auto --output eDP1 --off; bash ~/scripts/twoScreenStuff.sh; xmonad --restart")
  , ("M-S-C-\\", spawn "xrandr --output HDMI2 --scale 2x2 --panning 5120x2880+0+0 --primary --auto --output eDP1 --off; bash ~/scripts/twoScreenStuff.sh; xmonad --restart")


  {- AUDIO MANAGEMENT -}
  , ("<XF86AudioRaiseVolume>", spawn "pulseaudio-ctl up 2; bash ~/scripts/vol_xmobar.sh")
  , ("<XF86AudioLowerVolume>", spawn "pulseaudio-ctl down 2; bash ~/scripts/vol_xmobar.sh")
  , ("<XF86AudioMute>", spawn "pactl set-sink-mute 1 toggle || amixer set Master toggle; bash ~/scripts/vol_xmobar.sh")


  , ("<F11>", spawn "pulseaudio-ctl up 2; bash ~/scripts/vol_xmobar.sh")
  , ("<F10>", spawn "pulseaudio-ctl down 2; bash ~/scripts/vol_xmobar.sh")
  , ("<F12>", spawn "pactl set-sink-mute 1 toggle || amixer set Master toggle; bash ~/scripts/vol_xmobar.sh")

  -- , ("<XF86MonBrightnessDown>", spawn "xbacklight -inc -2")
  -- , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc +2")
  -- , ("M-<XF86MonBrightnessDown>", spawn "xbacklight -inc -0.1")
  -- , ("M-<XF86MonBrightnessUp>", spawn "xbacklight -inc +0.1")
  , ("<XF86MonBrightnessDown>", spawn "python ~/scripts/set_brightness.py dec")
  , ("<XF86MonBrightnessUp>", spawn "python ~/scripts/set_brightness.py inc")


  , ("<XF86AudioPrev>", spawn "python ~/scripts/media.py prev")
  , ("<XF86AudioNext>", spawn "python ~/scripts/media.py next")
  , ("<XF86AudioPlay>", spawn "python ~/scripts/media.py toggle")

  , ("M-<XF86AudioPlay>", spawn "python ~/scripts/media.py get-details > /tmp/xmonad.music")
  , ("M-<XF86AudioNext>", spawn "mpc random")
  , ("M-<XF86AudioPrev>", spawn "mpc repeat")

  , ("<F7>", spawn "python ~/scripts/media.py seek-prev && python ~/scripts/media.py get-time > /tmp/xmonad.music")
  , ("<F9>", spawn "python ~/scripts/media.py seek-next && python ~/scripts/media.py get-time > /tmp/xmonad.music")
  , ("<F8>", spawn "python ~/scripts/media.py get-time > /tmp/xmonad.music")


  , ("<F3>", spawn "python ~/scripts/media.py toggle")
  , ("<F4>", spawn "python ~/scripts/media.py prev")
  , ("<F5>", spawn "python ~/scripts/media.py next")

  , ("M-<F3>", spawn "python ~/scripts/media.py get-details > /tmp/xmonad.music")
  , ("M-<F4>", spawn "mpc repeat")
  , ("M-<F5>", spawn "mpc random")

  , ("S-<F4>", spawn "python ~/scripts/media.py seek-prev && python ~/scripts/media.py get-time > /tmp/xmonad.music")
  , ("S-<F5>", spawn "python ~/scripts/media.py seek-next && python ~/scripts/media.py get-time > /tmp/xmonad.music")
  , ("S-<F3>", spawn "python ~/scripts/media.py get-time > /tmp/xmonad.music")
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
