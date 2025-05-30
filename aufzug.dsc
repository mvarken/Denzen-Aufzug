# -------------------------------------------
# Aufzug
# Created by: mvarken
# GitHub: https://github.com/mvarken
#
# Requirements:
# Citizen Built
# Denizen Built
# -------------------------------------------
aufzug_world:
    type: world
    debug: false
    events:
        on player steps on heavy_weighted_pressure_plate:
        - wait 1t
        - define plate_location <context.location>
        - define gold_below <context.location.below>
        - if <[gold_below].material.name> != gold_block:
            - stop
        - define check_count 0
        - while <[check_count]> < 40:
            - wait 2t
            - define check_count <[check_count].add[1]>
            - if <player.velocity.y> > 0.3:
                - run aufzug_hoch_task def:<[plate_location]>
                - while stop
            - if <player.is_sneaking>:
                - run aufzug_runter_task def:<[plate_location]>
                - while stop
            - if <player.location.distance[<[plate_location].center>]> > 1.5:
                - while stop
aufzug_hoch_task:
    type: task
    debug: false
    definitions: plate_location
    script:
    - define current_y <[plate_location].y>
    - define base_x <[plate_location].x>
    - define base_z <[plate_location].z>
    - define higher_floors <list>
    - repeat 30:
        - define check_y <[current_y].add[<[value]>]>
        - define check_loc <location[<[base_x]>,<[check_y]>,<[base_z]>,<[plate_location].world>]>
        - define check_below <[check_loc].below>
        - if <[check_loc].material.name> == heavy_weighted_pressure_plate && <[check_below].material.name> == gold_block:
            - define higher_floors <[higher_floors].include[<[check_loc]>]>
    - if <[higher_floors].size> == 0:
        - stop
    - define target_floor <[higher_floors].sort_by_number[y].first>
    - define teleport_location <[target_floor].above.center.with_pitch[<player.location.pitch>].with_yaw[<player.location.yaw>]>
    - teleport <player> <[teleport_location]>
    - playsound <player> sound:entity_enderman_teleport pitch:1.2
    - playeffect <[plate_location].above> effect:portal quantity:15 offset:0.3
    - playeffect <[teleport_location]> effect:portal quantity:15 offset:0.3
aufzug_runter_task:
    type: task
    debug: false
    definitions: plate_location
    script:
    - define current_y <[plate_location].y>
    - define base_x <[plate_location].x>
    - define base_z <[plate_location].z>
    - define lower_floors <list>
    - repeat 30:
        - define check_y <[current_y].sub[<[value]>]>
        - if <[check_y]> < 1:
            - repeat next
        - define check_loc <location[<[base_x]>,<[check_y]>,<[base_z]>,<[plate_location].world>]>
        - define check_below <[check_loc].below>
        - if <[check_loc].material.name> == heavy_weighted_pressure_plate && <[check_below].material.name> == gold_block:
            - define lower_floors <[lower_floors].include[<[check_loc]>]>
    - if <[lower_floors].size> == 0:
        - stop
    - define target_floor <[lower_floors].sort_by_number[y].last>
    - define teleport_location <[target_floor].above.center.with_pitch[<player.location.pitch>].with_yaw[<player.location.yaw>]>
    - teleport <player> <[teleport_location]>
    - playsound <player> sound:entity_enderman_teleport pitch:0.8
    - playeffect <[plate_location].above> effect:portal quantity:15 offset:0.3
    - playeffect <[teleport_location]> effect:portal quantity:15 offset:0.3
