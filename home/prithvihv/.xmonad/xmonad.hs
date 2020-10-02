{-# LANGUAGE FlexibleContexts #-}
import           XMonad
import           XMonad.Config
import           XMonad.Hooks.DynamicLog
import           XMonad.Layout.MultiToggle
import           XMonad.Layout.MultiToggle.Instances
import           XMonad.Layout
import           XMonad.Layout.NoBorders
import           XMonad.Hooks.ManageDocks
import           XMonad.Util.Run                ( spawnPipe )
import           XMonad.Util.EZConfig           ( additionalKeys )
import           Graphics.X11.ExtraTypes.XF86
import           System.IO
import           System.Exit
import qualified Data.Map                      as M
import qualified XMonad.StackSet               as W
import           XMonad.Layout.Fullscreen
import           XMonad.Layout.NoBorders
import           XMonad.Layout.Spiral
import           XMonad.Layout.Grid
import           XMonad.Layout.Tabbed
import           XMonad.Layout.ThreeColumns
import           XMonad.Hooks.DynamicLog
import           XMonad.Actions.SpawnOn
import           XMonad.Hooks.UrgencyHook
import           XMonad.Layout.LayoutBuilder
import           XMonad.Layout.ResizableTile
import qualified XMonad.StackSet               as XS
import           XMonad.Hooks.ManageHelpers
import qualified System.Process                as SP
import qualified XMonad.Layout.ComboP           as XCombo
import           XMonad.Layout.TwoPane
import           XMonad.Layout.Named
import           XMonad.Layout.WindowNavigation
import qualified Data.Char as Char

capitalized :: String -> String
capitalized (head:tail) = Char.toUpper head : map Char.toLower tail
capitalized [] = []

-------------------------------------------------------------
-- App config strings
scrotParams =
  "-e 'xclip -selection clipboard -t image/png -i  $f && mv $f ~/Pictures/sshots'"
pathXmobar = "/home/prithvihv/code/bin/xmobar  "
myXmobarrc = "/home/prithvihv/.xmonad/xmobar-single"
myGUILuncher = "dmenu_run"
myPassManager = "/bin/bash /home/prithvihv/extras/dmenupass.sh"
-- myLockCmd = "xscreensaver-command -lock"
myLockCmd = "/bin/bash /home/prithvihv/.xmonad/bin/lockScreen"
myHibernateCmd = "xscreensaver-command -lock && sudo systemctl suspend"
myTerminal = "st -e \"/usr/bin/fish\" \"-C\" \"bterm\"" -- all terminals spawn a tmux :) 
myNextLayoutCmd = "xdotool key \"Super_L+space\""

-- colors
-- -- xmobar
xmobarCurrentWorkspaceColor = "#CEFFAC"
xmobarTitleColor = "#FFB6B0"
-- -- xmonad
myNormalBorderColor = "#000000"
myFocusedBorderColor = "#ffaa00"


myModMask = mod4Mask
myFocusFollowsMouse = True
myBorderWidth = 1

myWorkspaces =
  ["1:algo", "2:web_surf", "3:code", "4:text_web", "5:terminal", "6:work"]
    ++ map show [7 .. 8]
    ++ ["9:config"]

--------------------------------------------------------------
-- Key bindings
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@XConfig { XMonad.modMask = modMask } =
  M.fromList
    $ [ ((controlMask, xK_Print), spawn ("sleep 0.2; scrot -s " ++ scrotParams))
      , ((0, xK_Print)                , spawn ("scrot " ++ scrotParams))
      , ((modMask, xK_p)              , spawn myGUILuncher)
      , ((modMask .|. shiftMask, xK_p), spawn myPassManager)
      , ((modMask .|. shiftMask, xK_z), spawn myLockCmd)
      -- reenable this ones you figure out how toggling is set up
      -- , ((modMask, xK_Caps_Lock)      , sendMessage $ Toggle FULL)
      ]
    ++ [
    -- Y cant this be extracted from the default config
    -- Start a terminal.  Terminal to start is specified by myTerminal variable.
         ( (modMask .|. shiftMask, xK_Return)
         , spawn $ XMonad.terminal conf
         )

    -- Close focused window.
       , ( (modMask .|. shiftMask, xK_c)
         , kill
         )

  -- Cycle through the available layout algorithms.
       , ( (modMask, xK_space)
         , sendMessage NextLayout
         )

  --  Reset the layouts on the current workspace to default.
       , ( (modMask .|. shiftMask, xK_space)
         , setLayout $ XMonad.layoutHook conf
         )

  -- Resize viewed windows to the correct size.
       , ( (modMask, xK_n)
         , refresh
         )

  -- Move focus to the next window.
       , ( (modMask, xK_Tab)
         , windows W.focusDown
         )

  -- Move focus to the next window.
       , ( (modMask, xK_j)
         , windows W.focusDown
         )
       , ((modMask, xK_k), windows W.focusUp)
      -- only for Swap when using XCombo layout
       , ((modMask .|. controlMask , xK_j), sendMessage $ XCombo.SwapWindow )

  -- Move focus to the master window.
       , ( (modMask, xK_m)
         , windows W.focusMaster
         )

  -- Swap the focused window and the master window.
       , ( (modMask, xK_Return)
         , windows W.swapMaster
         )

  -- Swap the focused window with the next window.
       , ( (modMask .|. shiftMask, xK_j)
         , windows W.swapDown
         )

  -- Swap the focused window with the previous window.
       , ( (modMask .|. shiftMask, xK_k)
         , windows W.swapUp
         )

  -- Shrink the master area.
       , ( (modMask, xK_h)
         , sendMessage Shrink
         )

  -- Expand the master area.
       , ( (modMask, xK_l)
         , sendMessage Expand
         )

  -- Push window back into tiling.
       , ( (modMask, xK_t)
         , withFocused $ windows . W.sink
         )

  -- Increment the number of windows in the master area.
       , ( (modMask, xK_comma)
         , sendMessage (IncMasterN 1)
         )

  -- Decrement the number of windows in the master area.
       , ( (modMask, xK_period)
         , sendMessage (IncMasterN (-1))
         )

  -- Toggle the status bar gap.
  -- TODO: update this binding with avoidStruts, ((modMask, xK_b),

  -- Quit xmonad.
       , ((modMask .|. shiftMask, xK_q), io (exitWith ExitSuccess))
       , ( (modMask .|. shiftMask, xK_h)
         , io ((SP.createProcess (SP.proc myHibernateCmd [])) *> pure ())
         )
  -- Restart xmonad.
       , ((modMask, xK_q), restart "xmonad" True)
       ]
    ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
       [ ((m .|. modMask, k), windows $ f i)
       | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
       , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
       ]
    ++

  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
       [ ( (m .|. modMask, key)
         , screenWorkspace sc >>= flip whenJust (windows . f)
         )
       | (key, sc) <- zip [xK_w, xK_e, xK_r] [0 ..]
       , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
       ]

myManageHook = composeAll
  [ className =? "Blueman-manager" --> doShift (myWorkspaces !! 8)
    -- , resource  =? "desktop_window" --> doIgnore
    -- , className =? "Galculator"     --> doFloat
    -- , className =? "stalonetray"    --> doIgnore 
  -- , className =? "Arandr" --> doShift "9:config"
  , className =? "Nautilus" --> doCenterFloat
  -- , appName =? "Nemo" --> doCenterFloat 
  , className =? "discord" --> doShift (myWorkspaces !! 3)
  -- , className =? "slack"  --> doShift (myWorkspaces !! 3)
  , className =? "Pavucontrol" --> doShift (myWorkspaces !! 8)
  , className =? "typora" --> doShift (myWorkspaces !! 3)
  ]

myStartupHook = do
  -- spawnOn (myWorkspaces !! 9) "arandr"
  -- spawnOn (myWorkspaces !! 4) "typora"
  spawnOn (myWRef !! 8) "pavucontrol"
  -- spawnOn (myWorkspaces !! 9) "blueman-manger"
  -- set layout on startup not sure if its working !
  -- mapM_ (\_ -> spawnOn (myWorkspaces !! 9) myNextLayoutCmd) [1 .. 4]
  -- mapM_ (\_ -> spawnOn (myWorkspaces !! 3) myNextLayoutCmd) [1 .. 3]
  -- mapM_ (\_ -> spawnOn (myWorkspaces !! 4) myNextLayoutCmd) [1 .. 3]
  -- mapM_ (\_ -> spawnOn (myWorkspaces !! 2) myNextLayoutCmd) [1 .. 5]
  -- mapM_ (\_ -> spawnOn (myWorkspaces !! 5) myNextLayoutCmd) [1 .. 6]
  where
    myWRef =
      ["1:algo", "2:web_surf", "3:code", "4:text_web", "5:terminal", "6:work"]
        ++ map show [7 .. 8]
        ++ ["9:config"]

  -- updateLayout "9:config" ( Just $ spiral (6/7))
-- Workspaces 
-- The default number of workspaces (virtual screens) and their names.
--

lastFew :: Int -> String -> String
lastFew xs str = drop ((length str) - xs) str


tabConfig = defaultTheme { activeBorderColor   = "#44475a"
                         , activeTextColor     = "#f1fa8c"
                         , activeColor         = "#282a36"
                         , inactiveBorderColor = "#44475a"
                         , inactiveTextColor   = "#f8f8f2"
                         , inactiveColor       = "#282a36"
                        --  , fontName            = "xft:Fira Sans" -- not working right now!
                         }

  -- where defaultTab = tabbed shrinkText tabConfig

myLayout =
  avoidStruts
      (   Tall 1 (3 / 100) (2 / 3)
      -- ||| ThreeColMid 1 (3 / 100) (4 / 5)
      -- ||| custom1
      -- ||| 
      ||| doubleTab
      ||| Mirror (Tall 1 (3 / 100) (4 / 5))
      ||| tabbed shrinkText tabConfig
      ||| spiral (6 / 7)
      ||| Mirror (Tall 1 (3 / 100) (1 / 5))
      -- Mirror for weird screen settings
      )
    ||| noBorders (fullscreenFull Full)
 where
  doubleTab = named
    "2kill"
    (XCombo.combineTwoP (TwoPane 0.03 0.5)
                       (tabbed shrinkText tabConfig)
                       (tabbed shrinkText tabConfig)
                       (XCombo.Not $ XCombo.ClassName  (capitalized myTerminal))
    )

main = do
  xmproc <- spawnPipe (pathXmobar ++ myXmobarrc)
  xmonad $ fullscreenSupport $ defaults
    { layoutHook = avoidStruts $ layoutHook defaults
    , logHook    = dynamicLogWithPP xmobarPP
      { ppOutput  = hPutStrLn xmproc
      , ppTitle   = xmobarColor xmobarCurrentWorkspaceColor "" . lastFew 18
      , ppCurrent =
        (\ws -> xmobarColor xmobarCurrentWorkspaceColor "" (" " ++ ws ++ " "))
      , ppSep     = "  |   "
      }
    , manageHook = manageDocks <+> myManageHook
    }


-------------------------------------------------------------
defaults = defaultConfig {
    -- simple stuff
                           terminal           = myTerminal
                         , focusFollowsMouse  = myFocusFollowsMouse
                         , borderWidth        = myBorderWidth
                         , modMask            = myModMask
                         , workspaces         = myWorkspaces
                         , normalBorderColor  = myNormalBorderColor
                         , focusedBorderColor = myFocusedBorderColor

    -- key bindings
                         , keys               = myKeys
    -- ,mouseBindings      = myMouseBindings

    -- hooks, layouts
                         , layoutHook         = smartBorders $ myLayout
                         , startupHook        = myStartupHook
                         , handleEventHook    = docksEventHook
                         }
-- build and run
-- xmonad --recompile
-- xmonad --restart



-- extras
-- https://bitbucket.org/ideasman42/dotfiles/src/master/.xmonad/xmonad.hs
-- https://github.com/vicfryzel/xmonad-config/blob/master/xmonad.hs
-- https://hackage.haskell.org/package/xmonad-0.15/docs/XMonad-Layout.html
-- http://hackage.haskell.org/package/xmonad-contrib-0.8/docs/XMonad-Layout-MultiToggle.html
