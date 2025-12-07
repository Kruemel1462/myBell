Config = {}

-- Use ox_lib zones (true) or classic markers (false)
Config.UseOxLib = true

-- Use ox_lib for notifications
Config.UseOxLibNotifications = true

-- TextUI settings
--Config.BellInfobar = 'Klicke ~INPUT_PICKUP~, um zu klingeln'
--Config.BellInfobarOxLib = '[E] - Klingeln'
Config.BellInfobar = 'Click ~INPUT_PICKUP~, to bell'
Config.BellInfobarOxLib = '[E] - Bell'

-- Notification messages
--Config.BellMessage = 'Es wartet jemand bei ~y~'
--Config.BellMessageOxLib = 'Es wartet jemand bei '
Config.BellMessage = 'Someone is waiting at ~y~'
Config.BellMessageOxLib = 'Someone is waiting at '

Config.Bells = {
    {
        coords = vector3(441.72, -980.38, 31.09),
        name = 'Mission Row Police Department',
        job = 'police',
        -- ox_lib zone settings
        size = vector3(2.0, 2.0, 2.0),
        rotation = 0.0,
        debug = false -- set to true to see the zone
    },
    {
        coords = vector3(441.72, -960.38, 28.09),
        name = 'Mission Row Street',
        job = 'police',
        size = vector3(2.0, 2.0, 2.0),
        rotation = 0.0,
        debug = false
    },
}

-- Classic marker settings (only used when UseOxLib = false)
Config.Marker = {
    type = 0,
    color = { r = 255, g = 165, b = 0, a = 200 },
    size = { x = 0.2, y = 0.2, z = 0.25 }
}
