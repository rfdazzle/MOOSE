--- **Ops** - Commander Air Wing.
--
-- **Main Features:**
--
--    * Stuff
--
-- ===
--
-- ### Author: **funkyfranky**
-- @module Ops.WingCommander
-- @image OPS_WingCommander.png


--- WINGCOMMANDER class.
-- @type WINGCOMMANDER
-- @field #string ClassName Name of the class.
-- @field #boolean Debug Debug mode. Messages to all about status.
-- @field #string lid Class id string for output to DCS log file.
-- @field #table airwings Table of airwings.
-- @field #table missionqueue Mission queue.
-- @extends Ops.Intelligence#INTEL

--- Be surprised!
--
-- ===
--
-- ![Banner Image](..\Presentations\CarrierAirWing\WINGCOMMANDER_Main.jpg)
--
-- # The WINGCOMMANDER Concept
--
--
--
-- @field #WINGCOMMANDER
WINGCOMMANDER = {
  ClassName      = "WINGCOMMANDER",
  Debug          =   nil,
  lid            =   nil,
  airwings       =    {},
  missionqueue   =    {},
}

--- Mission resources.
-- @type WINGCOMMANDER.Recourses
-- 
-- @field #string missiontype Mission Type.
-- @field #number Ntot Total number of assets for this task.
-- @field #number Navail Number of available assets
-- @field #number Nonmission Number of assets currently on mission.

--- Contact details.
-- @type WINGCOMMANDER.Contact
-- @field Ops.Auftrag#AUFTRAG mission The assigned mission.
-- @extends Ops.Intelligence#INTEL.DetectedItem

--- WINGCOMMANDER class version.
-- @field #string version
WINGCOMMANDER.version="0.0.1"

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TODO list
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- TODO: Add tasks.
-- TODO: 

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Constructor
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Create a new WINGCOMMANDER object and start the FSM.
-- @param #WINGCOMMANDER self
-- @param Core.Set#SET_UNITS AgentSet Set of agents (units) providing intel. 
-- @return #WINGCOMMANDER self
function WINGCOMMANDER:New(AgentSet)

  -- Inherit everything from INTEL class.
  local self=BASE:Inherit(self, INTEL:New(AgentSet)) --#WINGCOMMANDER

  -- Set some string id for output to DCS.log file.
  self.lid=string.format("WINGCOMMANDER | ")

  -- Start State.
  --self:SetStartState("Stopped")
  
  -- Add FSM transitions.
  --                 From State  -->   Event        -->     To State
  --self:AddTransition("Stopped",       "Start",              "Running")     -- Start FSM.


  ------------------------
  --- Pseudo Functions ---
  ------------------------

  --- Triggers the FSM event "Start". Starts the WINGCOMMANDER. Initializes parameters and starts event handlers.
  -- @function [parent=#WINGCOMMANDER] Start
  -- @param #WINGCOMMANDER self

  --- Triggers the FSM event "Start" after a delay. Starts the WINGCOMMANDER. Initializes parameters and starts event handlers.
  -- @function [parent=#WINGCOMMANDER] __Start
  -- @param #WINGCOMMANDER self
  -- @param #number delay Delay in seconds.

  --- Triggers the FSM event "Stop". Stops the WINGCOMMANDER and all its event handlers.
  -- @param #WINGCOMMANDER self

  --- Triggers the FSM event "Stop" after a delay. Stops the WINGCOMMANDER and all its event handlers.
  -- @function [parent=#WINGCOMMANDER] __Stop
  -- @param #WINGCOMMANDER self
  -- @param #number delay Delay in seconds.

  --- Triggers the FSM event "Status".
  -- @function [parent=#WINGCOMMANDER] Status
  -- @param #WINGCOMMANDER self

  --- Triggers the FSM event "SkipperStatus" after a delay.
  -- @function [parent=#WINGCOMMANDER] __Status
  -- @param #WINGCOMMANDER self
  -- @param #number delay Delay in seconds.


  -- Debug trace.
  if false then
    self.Debug=true
    BASE:TraceOnOff(true)
    BASE:TraceClass(self.ClassName)
    BASE:TraceLevel(1)
  end
  self.Debug=true


  return self
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- User functions
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Add an airwing to the wingcommander.
-- @param #WINGCOMMANDER self
-- @param Ops.AirWing#AIRWING Airwing The airwing to add.
-- @return #WINGCOMMANDER self
function WINGCOMMANDER:AddAirwing(Airwing)

  --table.insert(self.airwings, Airwing)
  
  self.airwings[Airwing.alias]=Airwing
  
  return self
end


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Start & Status
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- On after Start event. Starts the FLIGHTGROUP FSM and event handlers.
-- @param #WINGCOMMANDER self
-- @param Wrapper.Group#GROUP Group Flight group.
-- @param #string From From state.
-- @param #string Event Event.
-- @param #string To To state.
function WINGCOMMANDER:onafterStart(From, Event, To)

  -- Short info.
  local text=string.format("Starting Wing Commander")
  self:I(self.lid..text)

  -- Start parent INTEL.
  self:GetParent(self).onafterStart(self, From, Event, To)

end

--- On after "Sitrep" event.
-- @param #WINGCOMMANDER self
-- @param Wrapper.Group#GROUP Group Flight group.
-- @param #string From From state.
-- @param #string Event Event.
-- @param #string To To state.
function WINGCOMMANDER:onafterStatus(From, Event, To)

  -- Start parent INTEL.
  self:GetParent(self).onafterStatus(self, From, Event, To)

  -- FSM state.
  local fsmstate=self:GetState()

  
  -- Clean up missions where the contact was lost.
  for _,_contact in pairs(self.ContactsLost) do
    local contact=_contact --#WINGCOMMANDER.Contact
    
    if contact.mission and contact.mission.airwing then
    
      -- Cancel this mission.
      contact.mission.airwing:MissionCancel(contact.mission)
          
    end
    
  end
  
 
  -- Create missions for all new contacts.
  for _,_contact in pairs(self.ContactsUnknown) do
    local contact=_contact --#WINGCOMMANDER.Contact
    local group=contact.group --Wrapper.Group#GROUP
    
    if group and group:IsAlive() then
    
      local category=group:GetCategory()
      local attribute=group:GetAttribute()
      local threatlevel=group:GetThreatLevel()
      
      local mission=nil --Ops.Auftrag#AUFTRAG
      
      if category==Group.Category.AIRPLANE or category==Group.Category.HELICOPTER then
                
        mission=AUFTRAG:NewINTERCEPT(group)
        
      elseif category==Group.Category.GROUND then
      
        --TODO: action depends on type
        -- AA/SAM ==> SEAD
        -- Tanks ==>
        -- Artillery ==>
        -- Infantry ==>
        -- 
                
        if attribute==GROUP.Attribute.GROUND_AAA or attribute==GROUP.Attribute.GROUND_SAM then
            
            --TODO: SEAD/DEAD
        
        end
        
        mission=AUFTRAG:NewBAI(group)
        
      
      elseif category==Group.Category.SHIP then
      
        --TODO: ANTISHIP
      
      end
      
      
      -- Add mission to queue.
      if mission then
        mission.nassets=1
        table.insert(self.missionqueue, mission)
      end
        
    end
    
  end
  
  
  -- Check mission queue and assign one PLANNED mission.
  self:CheckMissionQueue()

end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Resources
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Check mission queue and assign ONE planned mission.
-- @param #WINGCOMMANDER self 
function WINGCOMMANDER:CheckMissionQueue()

  for _,_mission in pairs(self.missionqueue) do
    local mission=_mission --Ops.Auftrag#AUFTRAG
    
    -- We look for PLANNED missions.
    if mission.status==AUFTRAG.Status.PLANNED then
    
      ---
      -- PLANNNED Mission
      ---
    
      -- Table of airwings that can do the mission.
      local airwings={}
    
      -- Loop over all airwings.
      for _,_airwing in pairs(self.airwings) do
        local airwing=_airwing --Ops.AirWing#AIRWING
        
        -- Check if airwing can do this mission.
        local can,assets=airwing:CanMission(mission.type, mission.nassets)
        
        -- Can it?
        if can then        
          
          -- Get coordinate of the target.
          local coord=mission:GetTargetCoordinate()
          
          if coord then
          
            -- Distance from airwing to target.
            local dist=coord:Get2DDistance(airwing:GetCoordinate())
          
            -- Add airwing to table of airwings that can.
            table.insert(airwings, {airwing=airwing, dist=dist, targetcoord=coord})
            
          end
          
        end
                
      end
      
      -- Can anyone?
      if #airwings>0 then
      
        -- Sort table wrt distace
        local function sortdist(a,b)
          return a.dist<b.dist
        end
        table.sort(airwings, sortdist)    
    
        local airwing=airwings[1].airwing  --Ops.AirWing#AIRWING
        local targetcoord=airwings[1].targetcoord --Core.Point#COORDINATE
        
        -- Get waypoint coordinate. This is where the mission is actually executed. 
        local WaypointCoordinate=airwing:GetCoordinate():GetIntermediateCoordinate(targetcoord, 0.5)
        
        -- Add mission to airwing.
        airwing:AddMission(mission, Nassets, WaypointCoordinate)
    
        return
      end
      
    else

      ---
      -- Missions NOT in PLANNED state
      ---    
    
    end
  
  end
  
end


--- Check resources.
-- @param #WINGCOMMANDER self
-- @return #table 
function WINGCOMMANDER:CheckResources()

  local capabilities={}
   
  for _,MissionType in pairs(AUFTRAG.Type) do
    capabilities[MissionType]=0
  
    for _,_airwing in pairs(self.airwings) do
      local airwing=_airwing --Ops.AirWing#AIRWING
        
      -- Get Number of assets that can do this type of missions.
      local _,assets=airwing:CanMission(MissionType)
      
      -- Add up airwing resources.
      capabilities[MissionType]=capabilities[MissionType]+#assets
    end
  
  end

  return capabilities
end

--- Check all airwings if they are able to do a specific mission type at a certain location with a given number of assets.
-- @param #WINGCOMMANDER self
-- @return Ops.AirWing#AIRWING The airwing object best for this mission.
function WINGCOMMANDER:GetAirwingForMission(MissionType, Coordinate, Nassets)

  --TODO: run over all airwings. sort by distance and available assets.

end


