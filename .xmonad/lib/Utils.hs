module Utils where

import XMonad
import XMonad.Actions.CycleWS
import XMonad.Util.WorkspaceCompare
import XMonad.Util.NamedWindows ( getName )

import qualified XMonad.StackSet as W

import Text.Printf (printf)
import System.Random

import Data.List (isInfixOf)

notiSpawn :: MonadIO m => String -> String -> m ()
notiSpawn noti cmd = spawn $ printf "notify-send '%s' -t 2000 && %s" noti cmd

notiLSpawn noti = notiSpawn $ "Launching: "++noti

--appStr app = "kioclient exec /usr/share/applications/" ++ app ++ ".desktop"

--notiApp noti app = notiSpawn noti $ appStr app

a +&& b = a ++ (' ':'&':'&':' ':b)
a +& b = a ++ (' ':'&':' ':b)

habakStr :: Int -> String
habakStr nScreens = printf "habak %s '/home/pierre/Pictures/wallpapers/chosen/%s'" habakStretch habakFolder
  where (habakStretch, habakFolder) = case nScreens of
		  1 -> ("-ms", "small")
		  2 -> ("-mC", "wide")


changeScreenNum :: MonadIO m => Int -> m ()
changeScreenNum screenMode = spawn str
	where str = nvidia +&& xmonad +&& "killall trayer" +&& "sleep 0.5" +&& twoScreenStuff
	      nvidia = printf "nvidia-settings -a 'CurrentMetaModeID=%d'" screenMode
	      twoScreenStuff = "bash ~/desktop_scripts/twoScreenStuff.sh"
	      xmonad = "xmonad --restart"



changeBackground :: MonadIO m => Int -> m ()
changeBackground = spawn . habakStr

notesFile, journalDateFormat, journalFile :: String
notesFile = "/home/pierre/Dropbox/org/notes.org"
journalDateFormat = "%Y_%m_%d" --"%b_%d_%Y"
journalFile = printf "/home/pierre/Dropbox/fun/compositions/journal/`date +%s`.journal" journalDateFormat

todoFile =  "/home/pierre/Dropbox/lists/todo.txt"

lockScreenCmd :: String
lockScreenCmd = "xlock -mode blank -echokeys -echokey '*'"

editor :: String
editor = "emacsclient --alternate-editor='emacs' -c"

spawnEdit :: MonadIO m => String -> m ()
spawnEdit file = spawn $ printf "%s %s" editor file

-- myXPConfig = defaultXPConfig { fgColor = "white" --
-- 	                     , bgColor = "black"
-- 			     , borderColor = "black"
-- 			     , font = "xft:Dina:pixelsize=12,-*-*-*-R-Condensed-*-*-*-*-*-*-*-ISO8859-1"
			     -- }

appendMusicFile :: MonadIO m => m ()
appendMusicFile = spawn cmd
  where cmd = getMusic +&& sendNotification
        getMusic = printf "bash %s --no-format >> %s" scriptFilename outputFilename
        scriptFilename = "~/desktop_scripts/exaile_music.sh"
        outputFilename = "~/Dropbox/good_music"
        sendNotification = printf "notify-send -t %d \"SAVED: `tail -n 1 %s`\"" notificationDelay outputFilename
        notificationDelay = 1300 :: Int


moveWS b  = do t <- findWorkspace getSortByTag b AnyWS 1
               windows . W.greedyView $ t


movieBaseFolder = "/home/pierre/Pictures/wallpapers/frames"


movieFrameFolders = [ ("ms", "porco")
               , ("ms", "chihiro")
               , ("ms", "pompoko")
               -- , ("mS", "garden_words")
               -- , ("ms", "wolf_children")
               , ("ms", "kiki")
               -- , ("mS", "hoshi_wo_ou_kodomo")
               , ("mS", "5cm")
               ]

artBaseFolder = "/home/pierre/Pictures/wallpapers/art"


artFrameFolders = [ ("ms", "gravity"),
                    ("ms", "gravity2")
               ]


pokemonBaseFolder = "/home/pierre/Pictures/wallpapers/pokemon"
pokemonFolders = [("ms", "hoenn"),
                  ("ms", "johto"),
                  ("ms", "kanto"),
                  ("ms", "sinnoh")]


-- should generate something like "habak -mS '/home/pierre/Pictures/wallpapers/frames/garden_words/'"

getRandHabak :: String -> [(String, String)] -> IO String
getRandHabak baseFolder frameFolders = do
             index <- randomRIO (0, length frameFolders - 1)
             let (param, folder) = frameFolders !! index
             return $ printf "echo habak -%s %s/%s >> ~/Dropbox/random/backgrounds.log; habak -%s %s/%s" param baseFolder folder param baseFolder folder



randomBackground base folders = liftIO $ (getRandHabak base folders) >>= spawn


changeVideoBackground, changeArtBackground, changePokemonBackground :: MonadIO m => m ()
changeVideoBackground = randomBackground movieBaseFolder movieFrameFolders
changeArtBackground = randomBackground artBaseFolder artFrameFolders
changePokemonBackground = randomBackground pokemonBaseFolder pokemonFolders


changeWorkspaceBackground :: String -> X ()
changeWorkspaceBackground name = spawn command
    where command = printf "habak -ms ~/Pictures/wallpapers/chosen/small-desktops/%s" name

bookPath = "/home/pierre/Dropbox/reading/current"

redrawWindows :: X ()
redrawWindows = withFocused (\w ->  (fmap show $ getName w) >>= \title -> if (isInfixOf "emacs" title) then reallyRedrawWindows else return () )

reallyRedrawWindows :: X ()
reallyRedrawWindows = spawn "xfce4-terminal -e '/usr/bin/sleep 0.02'"

-- redrawWindows = spawn "/usr/bin/sleep 0.05"
-- redrawWindows = withFocused (windows . ((flip W.float) (W.RationalRect 0 40 2500 1500))) >> withFocused (windows . W.sink) >> rescreen

updateWorkspaceBar :: X ()
updateWorkspaceBar =  spawn "/usr/bin/python3 ~/scripts/get_workspaces.py > /tmp/xmobar.ws"

