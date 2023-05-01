
This game demonstrates how to use sprite groups and collidesWith masks to control which sprites should collide with one another.

The methods involved are:

Group-assignment:

These methods allow you to assign sprites to certain layers using a 32-bit mask, or by using the convenience setGroups() method. By default a sprite is a member of all groups.

sprite:setGroupMask()
sprite:setGroups(layers)
sprite:getGroupMask()
sprite:resetGroupMask()

Collision layer assignment:

Sprites only collide if the moving sprite's collidesWith mask matches at least one group of a potential collision sprite (i.e. a bitwise AND (&) between the moving sprite's collidesWith mask and a potential collision sprite's groupMask != zero). By default sprites without masks set can collide with other sprites that also don't have a mask.

sprite:setCollidesWithGroupsMask()
sprite:setCollidesWithGroups(layers)
sprite:getCollidesWithGroupsMask()
sprite:resetCollidesWithGroupsMask()
