using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class RescueTeam
{
    public int TeamId { get; set; }

    public string TeamName { get; set; } = null!;

    public string TeamType { get; set; } = null!;

    public int LocationId { get; set; }

    public string CurrentStatus { get; set; } = null!;

    public virtual Location Location { get; set; } = null!;

    public virtual ICollection<RescueAssignment> RescueAssignments { get; set; } = new List<RescueAssignment>();

    public virtual ICollection<TeamMember> TeamMembers { get; set; } = new List<TeamMember>();
}
