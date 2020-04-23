--- **Wrapper** - Markers On the F10 map.
-- 
-- **Main Features:**
--
--    * Convenient handling of markers via multiple user API functions.
--    * Update text and position of marker easily via scripting.
--    * Delay creation and removal of markers via (optional) parameters.
--    * Retrieve data such as text and coordinate.
--    * Marker specific FSM events when a marker is added, removed or changed.
--    * Additional FSM events when marker text or position is changed.
--     
-- ===
--
-- ### Author: **funkyfranky**
-- @module Wrapper.Marker
-- @image Wrapper_Marker.png


--- Marker class.
-- @type MARKER
-- @field #string ClassName Name of the class.
-- @field #boolean Debug Debug mode. Messages to all about status.
-- @field #string lid Class id string for output to DCS log file.
-- @field #number mid Marker ID.
-- @field Core.Point#COORDINATE coordinate Coordinate of the mark.
-- @field #string text Text displayed in the mark panel.
-- @field #string message Message dispayed when the mark is added.
-- @field #boolean readonly Marker is read-only.
-- @field #number coalition Coalition to which the marker is displayed.
-- @extends Core.Fsm#FSM

--- **Ground Control**: Airliner X, Good news, you are clear to taxi to the active.
--  **Pilot**: Roger, What's the bad news?
--  **Ground Control**: No bad news at the moment, but you probably want to get gone before I find any.
--
-- ===
--
-- ![Banner Image](..\Presentations\MARKER\Marker_Main.jpg)
--
-- # The MARKER Class Idea
-- 
-- # Creat a Marker
-- 
-- ## For Everyone
-- 
-- ## For a Coaliton
-- 
-- ## For a Group
-- 
-- 
-- # Update a Marker
-- 
-- ## Update Text
-- 
-- ## Update Coordinate
-- 
-- 
-- # Retrieve Data
-- 
-- ## Text
-- 
-- ## Coordinate
-- 
-- 
-- # FSM Events
-- 
-- ## Added
-- 
-- ## Changed
-- 
-- ## Removed
-- 
-- ## TextUpdate
-- 
-- ## CoordUpdate
-- 
-- 
-- # Examples
-- 
-- 
-- @field #MARKER
MARKER = {
  ClassName      = "MARKER",
  Debug          = false,
  lid            =   nil,
  mid            =   nil,
  coordinate     =   nil,
  text           =   nil,
  message        =   nil,
  readonly       =   nil,
  coalition      =   nil,
}

--- Marker ID. Running number.
_MARKERID=0

--- Marker class version.
-- @field #string version
MARKER.version="0.1.0"

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TODO list
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- TODO: User "Get" functions. E.g., :GetCoordinate()
-- DONE: Add delay to user functions.
-- DONE: Handle events.
-- DONE: Create FSM events.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Constructor
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Create a new MARKER class object.
-- @param #MARKER self
-- @param Core.Point#COORDINATE Coordinate Coordinate where to place the marker.
-- @param #string Text Text displayed on the mark panel. 
-- @return #MARKER self
function MARKER:New(Coordinate, Text)

  -- Inherit everything from FSM class.
  local self=BASE:Inherit(self, FSM:New()) -- #MARKER
  
  self.coordinate=Coordinate
  
  self.text=Text
  
  -- Defaults
  self.readonly=false
  self.message=""
  
  -- New marker ID. This is not the one of the actual marker.  
  _MARKERID=_MARKERID+1
  
  self.myid=_MARKERID
  
  -- Log ID.
  self.lid=string.format("Marker #%d | ", self.myid)
  
  -- Start State.
  self:SetStartState("Invisible")

  -- Add FSM transitions.
  --                 From State  -->   Event      -->     To State
  self:AddTransition("Invisible",     "Added",           "Visible")     -- Marker was added.
  self:AddTransition("Visible",       "Removed",         "Invisible")   -- Marker was removed.
  self:AddTransition("*",             "Changed",         "*")           -- Marker was changed.
  
  self:AddTransition("*",             "TextUpdate",      "*")           -- Text updated.
  self:AddTransition("*",             "CoordUpdate",     "*")           -- Coordinates updated.

  --- Triggers the FSM event "Added".
  -- @function [parent=#MARKER] Added
  -- @param #MARKER self
  -- @param Core.Event#EVENTDATA EventData Event data table.

  --- Triggers the delayed FSM event "Added".
  -- @function [parent=#MARKER] __Added
  -- @param #MARKER self
  -- @param Core.Event#EVENTDATA EventData Event data table.

  --- On after "Added" event user function.
  -- @function [parent=#MARKER] OnAfterAdded
  -- @param #MARKER self
  -- @param #string From From state.
  -- @param #string Event Event.
  -- @param #string To To state.
  -- @param Core.Event#EVENTDATA EventData Event data table.


  --- Triggers the FSM event "Removed".
  -- @function [parent=#MARKER] Removed
  -- @param #MARKER self
  -- @param Core.Event#EVENTDATA EventData Event data table.

  --- Triggers the delayed FSM event "Removed".
  -- @function [parent=#MARKER] __Removed
  -- @param #MARKER self
  -- @param Core.Event#EVENTDATA EventData Event data table.

  --- On after "Removed" event user function.
  -- @function [parent=#MARKER] OnAfterRemoved
  -- @param #MARKER self
  -- @param #string From From state.
  -- @param #string Event Event.
  -- @param #string To To state.
  -- @param Core.Event#EVENTDATA EventData Event data table.


  --- Triggers the FSM event "Changed".
  -- @function [parent=#MARKER] Changed
  -- @param #MARKER self
  -- @param Core.Event#EVENTDATA EventData Event data table.

  --- Triggers the delayed FSM event "Changed".
  -- @function [parent=#MARKER] __Changed
  -- @param #MARKER self
  -- @param Core.Event#EVENTDATA EventData Event data table.

  --- On after "Changed" event user function.
  -- @function [parent=#MARKER] OnAfterChanged
  -- @param #MARKER self
  -- @param #string From From state.
  -- @param #string Event Event.
  -- @param #string To To state.
  -- @param Core.Event#EVENTDATA EventData Event data table.


  --- Triggers the FSM event "TextUpdate".
  -- @function [parent=#MARKER] TextUpdate
  -- @param #MARKER self
  -- @param #string Text The new text.

  --- Triggers the delayed FSM event "TextUpdate".
  -- @function [parent=#MARKER] __TextUpdate
  -- @param #MARKER self
  -- @param #string Text The new text.

  --- On after "TextUpdate" event user function.
  -- @function [parent=#MARKER] OnAfterTextUpdate
  -- @param #MARKER self
  -- @param #string From From state.
  -- @param #string Event Event.
  -- @param #string To To state.
  -- @param #string Text The new text.


  --- Triggers the FSM event "CoordUpdate".
  -- @function [parent=#MARKER] CoordUpdate
  -- @param #MARKER self
  -- @param Core.Point#COORDINATE Coordinate The new Coordinate.

  --- Triggers the delayed FSM event "CoordUpdate".
  -- @function [parent=#MARKER] __CoordUpdate
  -- @param #MARKER self
  -- @param Core.Point#COORDINATE Coordinate The updated Coordinate.

  --- On after "CoordUpdate" event user function.
  -- @function [parent=#MARKER] OnAfterCoordUpdate
  -- @param #MARKER self
  -- @param #string From From state.
  -- @param #string Event Event.
  -- @param #string To To state.
  -- @param Core.Point#COORDINATE Coordinate The updated Coordinate.


  -- Handle events.
  self:HandleEvent(EVENTS.MarkAdded)
  self:HandleEvent(EVENTS.MarkRemoved)
  self:HandleEvent(EVENTS.MarkChange)
  
  return self  
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- User API Functions
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Marker is readonly. Text cannot be changed and marker cannot be removed.
-- @param #MARKER self
-- @return #MARKER self
function MARKER:ReadOnly()

  self.readonly=true
  
  return self
end

--- Set message that is displayed on screen if the marker is added.
-- @param #MARKER self
-- @param #string Text Message displayed when the marker is added.
-- @return #MARKER self
function MARKER:Message(Text)

  self.message=Text or ""
  
  return self
end

--- Place marker visible for everyone.
-- @param #MARKER self
-- @param #number Delay (Optional) Delay in seconds, before the marker is created.
-- @return #MARKER self
function MARKER:ToAll(Delay)

  if Delay and Delay>0 then
    self:ScheduleOnce(Delay, MARKER.ToAll, self)
  else

    self.toall=true
  
    -- First remove an existing mark.
    if self.shown then    
      self:Remove()    
    end
    
    self.mid=UTILS.GetMarkID()
  
    -- Call DCS function.
    trigger.action.markToAll(self.mid, self.text, self.coordinate:GetVec3(), self.readonly, self.message)

  end

  return self
end

--- Place marker visible for a specific coalition only.
-- @param #MARKER self
-- @param #number Coalition Coalition 1=Red, 2=Blue, 0=Neutral. See `coaliton.side.RED`.
-- @param #number Delay (Optional) Delay in seconds, before the marker is created.
-- @return #MARKER self
function MARKER:ToCoalition(Coalition, Delay)

  if Delay and Delay>0 then
    self:ScheduleOnce(Delay, MARKER.ToCoalition, self, Coalition)
  else

    self.coalition=Coalition
    
    self.tocoaliton=true
    
    -- First remove an existing mark.
    if self.shown then    
      self:Remove()    
    end
    
    self.mid=UTILS.GetMarkID()
    
    -- Call DCS function.
    trigger.action.markToCoalition(self.mid, self.text, self.coordinate:GetVec3(), self.coalition, self.readonly, self.message)
    
  end
  
  return self
end

--- Place marker visible for the blue coalition only.
-- @param #MARKER self
-- @param #number Delay (Optional) Delay in seconds, before the marker is created.
-- @return #MARKER self
function MARKER:ToBlue(Delay)
  self:ToCoalition(coalition.side.BLUE, Delay)
  return self
end

--- Place marker visible for the blue coalition only.
-- @param #MARKER self
-- @param #number Delay (Optional) Delay in seconds, before the marker is created.
-- @return #MARKER self
function MARKER:ToRed(Delay)
  self:ToCoalition(coalition.side.RED, Delay)
  return self
end

--- Place marker visible for the neutral coalition only.
-- @param #MARKER self
-- @param #number Delay (Optional) Delay in seconds, before the marker is created.
-- @return #MARKER self
function MARKER:ToNeutral(Delay)
  self:ToCoalition(coalition.side.NEUTRAL, Delay)
  return self
end


--- Place marker visible for a specific group only.
-- @param #MARKER self
-- @param Wrapper.Group#GROUP Group The group to which the marker is displayed.
-- @param #number Delay (Optional) Delay in seconds, before the marker is created.
-- @return #MARKER self
function MARKER:ToGroup(Group, Delay)

  if Delay and Delay>0 then
    self:ScheduleOnce(Delay, MARKER.ToGroup, self, Group)
  else

    -- Check if group exists.
    if Group and Group:IsAlive()~=nil then
  
      self.groupid=Group:GetID()
      
      if self.groupid then
  
        self.groupname=Group:GetName()
            
        self.togroup=true
        
        -- First remove an existing mark.
        if self.shown then    
          self:Remove()    
        end
        
        self.mid=UTILS.GetMarkID()
      
        -- Call DCS function.
        trigger.action.markToGroup(self.mid, self.text, self.coordinate:GetVec3(), self.groupid, self.readonly, self.message)
        
      end
      
    else
      --TODO: Warning!    
    end
    
  end
  
  return self
end

--- Update the text displayed on the mark panel.
-- @param #MARKER self
-- @param #string Text Updated text.
-- @param #number Delay (Optional) Delay in seconds, before the marker is created.
-- @return #MARKER self
function MARKER:UpdateText(Text, Delay)

  if Delay and Delay>0 then
    self:ScheduleOnce(Delay, MARKER.UpdateText, self, Text)
  else  

    self.text=tostring(Text)
    
    self:Refresh()
    
    self:TextUpdate(tostring(Text))
    
  end

end

--- Update the coordinate where the marker is displayed.
-- @param #MARKER self
-- @param Core.Point#COORDINATE Coordinate The new coordinate.
-- @param #number Delay (Optional) Delay in seconds, before the marker is created.
-- @return #MARKER self
function MARKER:UpdateCoordinate(Coordinate, Delay)

  if Delay and Delay>0 then
    self:ScheduleOnce(Delay, MARKER.UpdateCoordinate, self, Coordinate)
  else  

    self.coordinate=Coordinate
    
    self:Refresh()
    
    self:CoordUpdate(Coordinate)
    
  end

end

--- Refresh the marker.
-- @param #MARKER self
-- @param #number Delay (Optional) Delay in seconds, before the marker is created.
-- @return #MARKER self
function MARKER:Refresh(Delay)

  if Delay and Delay>0 then
    self:ScheduleOnce(Delay, MARKER.Refresh, self)
  else  

    if self.toall then
    
      self:ToAll()
   
    elseif self.tocoaliton then
    
      self:ToCoalition(self.coalition)
    
    elseif self.togroup then
    
      local group=GROUP:FindByName(self.groupname)
    
      self:ToGroup(group)
    
    else
      self:E(self.lid.."ERROR: unknown To in :Refresh()!")
    end
    
  end

end

--- Remove a marker.
-- @param #MARKER self
-- @param #number Delay (Optional) Delay in seconds, before the marker is created.
-- @return #MARKER self
function MARKER:Remove(Delay)

  if Delay and Delay>0 then
    self:ScheduleOnce(Delay, MARKER.Remove, self)
  else

    -- Call DCS function.
    trigger.action.removeMark(self.mid)
    
  end

end

--- Get position of the marker.
-- @param #MARKER self
-- @return Core.Point#COORDINATE The coordinate of the marker.
function MARKER:GetCoordinate()
  return self.coordinate
end

--- Get text that is dispayed in the marker panal.
-- @param #MARKER self
-- @return #string Marker text.
function MARKER:GetText()
  return self.text
end


--- Check if marker is currently visible on the F10 map.
-- @param #MARKER self
-- @return #boolean True if the marker is currently visible.
function MARKER:IsVisible()
  return self:Is("Visible")
end

--- Check if marker is currently invisible on the F10 map.
-- @param #MARKER self
-- @return 
function MARKER:IsInvisible()
  return self:Is("Invisible")
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Event Functions
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Event function when a MARKER is added.
-- @param #MARKER self
-- @param Core.Event#EVENTDATA EventData
function MARKER:OnEventMarkAdded(EventData)

  if EventData and EventData.MarkID then
  
    local MarkID=EventData.MarkID
    
    self:T3(self.lid..string.format("Captured event MarkAdded for Mark ID=%s", tostring(MarkID)))
    
    if MarkID==self.mid then
        
      self.shown=true
      
      self:Added(EventData)
    
    end

  end

end

--- Event function when a MARKER is removed.
-- @param #MARKER self
-- @param Core.Event#EVENTDATA EventData
function MARKER:OnEventMarkRemoved(EventData)

  if EventData and EventData.MarkID then
  
    local MarkID=EventData.MarkID
    
    self:T3(self.lid..string.format("Captured event MarkAdded for Mark ID=%s", tostring(MarkID)))
    
    if MarkID==self.mid then
        
      self.shown=false
      
      self:Removed(EventData)
    
    end

  end
  
end

--- Event function when a MARKER changed.
-- @param #MARKER self
-- @param Core.Event#EVENTDATA EventData
function MARKER:OnEventMarkChange(EventData)

  if EventData and EventData.MarkID then
  
    local MarkID=EventData.MarkID
    
    self:T3(self.lid..string.format("Captured event MarkChange for Mark ID=%s", tostring(MarkID)))
    
    if MarkID==self.mid then
        
      self:Changed(EventData)
      
      self:TextChanged(tostring(EventData.MarkText))
    
    end

  end

end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FSM Event Functions
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- On after "Added" event.
-- @param #MARKER self
-- @param #string From From state.
-- @param #string Event Event.
-- @param #string To To state.
-- @param Core.Event#EVENTDATA EventData Event data table.
function MARKER:onafterAdded(From, Event, To, EventData)

  -- Debug info.
  local text=string.format("Captured event MarkAdded for myself:\n")      
  text=text..string.format("Marker ID  = %s\n",   tostring(EventData.MarkID))
  text=text..string.format("Coalition  = %s\n",   tostring(EventData.MarkCoalition))
  text=text..string.format("Group  ID  = %s\n",   tostring(EventData.MarkGroupID))
  text=text..string.format("Initiator  = %s\n",   EventData.IniUnit and EventData.IniUnit:GetName() or "Nobody")
  text=text..string.format("Coordinate = %s\n",   EventData.MarkCoordinate and EventData.MarkCoordinate:ToStringLLDMS() or "Nowhere")
  text=text..string.format("Text:          \n%s", tostring(EventData.MarkText))
  self:T2(self.lid..text)

end

--- On after "Removed" event.
-- @param #MARKER self
-- @param #string From From state.
-- @param #string Event Event.
-- @param #string To To state.
-- @param Core.Event#EVENTDATA EventData Event data table.
function MARKER:onafterRemoved(From, Event, To, EventData)

  -- Debug info.
  local text=string.format("Captured event MarkRemoved for myself:\n")      
  text=text..string.format("Marker ID  = %s\n",   tostring(EventData.MarkID))
  text=text..string.format("Coalition  = %s\n",   tostring(EventData.MarkCoalition))
  text=text..string.format("Group  ID  = %s\n",   tostring(EventData.MarkGroupID))
  text=text..string.format("Initiator  = %s\n",   EventData.IniUnit and EventData.IniUnit:GetName() or "Nobody")
  text=text..string.format("Coordinate = %s\n",   EventData.MarkCoordinate and EventData.MarkCoordinate:ToStringLLDMS() or "Nowhere")
  text=text..string.format("Text:          \n%s", tostring(EventData.MarkText))
  self:T2(self.lid..text)

end

--- On after "Changed" event.
-- @param #MARKER self
-- @param #string From From state.
-- @param #string Event Event.
-- @param #string To To state.
-- @param Core.Event#EVENTDATA EventData Event data table.
function MARKER:onafterChanged(From, Event, To, EventData)

  -- Debug info.
  local text=string.format("Captured event MarkChange for myself:\n")      
  text=text..string.format("Marker ID  = %s\n",   tostring(EventData.MarkID))
  text=text..string.format("Coalition  = %s\n",   tostring(EventData.MarkCoalition))
  text=text..string.format("Group  ID  = %s\n",   tostring(EventData.MarkGroupID))
  text=text..string.format("Initiator  = %s\n",   EventData.IniUnit and EventData.IniUnit:GetName() or "Nobody")
  text=text..string.format("Coordinate = %s\n",   EventData.MarkCoordinate and EventData.MarkCoordinate:ToStringLLDMS() or "Nowhere")
  text=text..string.format("Text:          \n%s", tostring(EventData.MarkText))
  self:T2(self.lid..text)

end

--- On after "TextUpdate" event.
-- @param #MARKER self
-- @param #string From From state.
-- @param #string Event Event.
-- @param #string To To state.
-- @param #string Text The updated text, displayed in the mark panel.
function MARKER:onafterTextUpdate(From, Event, To, Text)

  self:I(self.lid..string.format("New Marker Text:\n%s", Text))

end

--- On after "CoordUpdate" event.
-- @param #MARKER self
-- @param #string From From state.
-- @param #string Event Event.
-- @param #string To To state.
-- @param Core.Point#COORDINATE Coordinate The updated coordinates.
function MARKER:onafterCoordUpdate(From, Event, To, Coordinate)

  self:I(self.lid..string.format("New Marker Coordinate in LL DMS: %s", Coordinate:ToStringLLDMS()))
  
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------