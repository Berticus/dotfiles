import XMonad 
import System.IO
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map as M
import Data.Ratio

-- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.LayoutHints
import XMonad.Layout.ResizableTile

-- Utils


-- Hooks
import XMonad.Hooks.ManageDocks

main = xmonad $ defaultConfig
    { borderWidth         = 1
    , terminal            = "urxvtc"
    , normalBorderColor   = "black"
    , focusedBorderColor  = "purple"
    , focusFollowsMouse   = True
    , startupHook         = spawn "~/.xprofile"
    , layoutHook          = myLayout
    , keys                = myKeys
    , manageHook          = manageDocks <+> myManageHook <+> manageHook defaultConfig
    }

--myLayout = Accordion ||| layoutHints (Mirror tiled) ||| Full
myLayout = avoidStruts (Accordion ||| Mirror tiled ||| Full)
    where
        tiled   = ResizableTall nmaster delta ratio []
        nmaster = 1
        ratio   = 1/4
        delta   = 3/100

-- key bindings
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    -- launch dmenu
    , ((modm,               xK_p     ), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")
    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)
     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    -- Resize viewed windows to the correct size
    , ((modm .|. shiftMask, xK_r     ), refresh)
    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)
    -- Move focus to the next window
    , ((modm,               xK_k     ), windows W.focusUp  )
    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)
    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )
    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)
    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++
 
    --
    -- mod-[1..9], Switch to workspace N
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
 
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
 
 
