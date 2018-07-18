module Layout where

import XMonad


import XMonad.Layout.Accordion
-- import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Circle
import XMonad.Layout.Cross
import XMonad.Layout.Spiral
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.SimpleDecoration
import XMonad.Layout.Roledex
import XMonad.Layout.Magnifier
import XMonad.Layout.StackTile
import XMonad.Layout.NoBorders


import XMonad.Layout.ComboP
import XMonad.Layout.ResizableTile
-- import XMonad.Layout.MagicFocus
import XMonad.Layout.NoBorders
import XMonad.Layout.IndependentScreens
import XMonad.Layout.IM
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Spacing
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Tabbed
--import XMonad.Layout.TabBarDecoration
import XMonad.Layout.TwoPane
import XMonad.Layout.Reflect
import XMonad.Layout.Grid

import XMonad.Config.Desktop
import XMonad.ManageHook
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Layout.LayoutBuilder

import XMonad.Util.Themes
import qualified XMonad.StackSet as W

import Data.Ratio ((%))

-- spacing between windows
mySpacing = 0 -- pixels

-- The default number of windows in the master pane
nmaster = 1

-- Percent of screen to increment by when resizing panes
delta   = 3/100

-- Default proportion of screen occupied by master pane
goldenRatio = toRational $ 2/(1 + sqrt 5 :: Double)
ratio  = goldenRatio

-- Ratio of screen that roster will occupy
imListRatio = 1%6

myLayout =  lessBorders (Combine Union Screen OtherIndicated) . avoidStruts $
                   onWorkspaces ["0", "0_0", "1_0"] experimentalLayout $
		   onWorkspaces ["8", "0_8", "1_8"] (gimpLayout ||| normalLayout) $
                   onWorkspaces ["6", "0_6", "1_6"] (imLayout ||| normalLayout) $
		   -- tiled ||| Mirror tiled ||| Full ||| simplestFloat
                   normalLayout
  where
	tiled = ResizableTall nmaster delta ratio []

        gimpLayout = combineTwoP (TwoPane 0.03 0.15) tiled
				 (reflectHoriz $ combineTwoP (TwoPane 0.03 0.2) tiled (tiled ||| Grid)
		                                                      (Role "gimp-dock"))
                                 (Role "gimp-toolbox")

        myTabs = tabbedBottom shrinkText tabTheme

        tabTheme = (theme wfarrTheme) {
                     fontName = "xft:Open Sans:pixelsize=24,-*-*-*-R-Condensed-*-*-*-*-*-*-*-ISO8859-1"
                   , activeColor = "#2e485c" -- "#4c7899"
                   , decoHeight = 30 }

        experimentalLayout = smartSpacing mySpacing (StackTile nmaster delta (1/2)) ||| spiral goldenRatio ||| Accordion ||| Circle ||| simpleCross
                             ||| myTabs
                             ||| noFrillsDeco shrinkText tabTheme tiled
                             ||| tallTabbed
                                --- ||| magnifier tiled ||| Grid

        normalLayout = smartSpacing mySpacing tiled ||| smartSpacing mySpacing (StackTile nmaster delta (1/2))
                       ||| noBorders myTabs
                       ||| noBorders Full ||| simplestFloat

        tallTabbed = layoutN 1 (relBox 0 0 0.5 1) (Just $ relBox 0 0 1 1) Full
                     $ layoutN 1 (relBox 0.5 0 1 0.5) (Just $ relBox 0.5 0 1 1) Full
                     $ layoutAll (relBox 0.5 0.5 1 1) (tabbedBottom shrinkText tabTheme)


        imLayout = withIM imListRatio (Role "buddy_list") Grid
        -- imLayout = Grid


myManageHook = composeAll
			  [
                           isDialog --> doFloat
                          , resource =? "Do" --> doIgnore
                          , resource =? "synapse" --> doIgnore
			  , resource =? "xfce4-notifyd"  --> doIgnore
			  , resource =? "xjump" --> doFloat
			  , resource =? "Toplevel" --> doFloat
			  , resource =? "Extension" --> doFloat
			  , resource =? "xmessage" --> doCenterFloat
			  , className =? "Pinentry" --> doCenterFloat
				--               , resource =? "Gimp-2.6" --> doFloat
			  , className =? "Gimp" --> doFloat
			  -- , className =? "Gnome-terminal" --> doF (W.swapDown)
			  -- , className =? "Xfce4-terminal" --> doF (W.swapDown)
			  -- , className =? "Emacs" --> doF (W.swapDown)
			  , className =? "Tilem" --> doFloat
                          , className =? "sun-awt-X11-XFramePeer" --> doFloat
                          , className =? "com-mathworks-util-PostVMInit" --> doFloat
                            
			  , title =? "Run Application" --> doFloat
			  -- , title =? "Upload Variables" --> doF (W.swapDown)
                          , title =? "MPlayer" --> doShift "9"
			  , isFullscreen --> doFullFloat
			  ]

newManageHook = myManageHook <+> manageHook desktopConfig <+> doF (W.swapDown)
