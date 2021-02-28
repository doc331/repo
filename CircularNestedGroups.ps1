Function Get-CircularNestedGroups {
    $groups  = Get-ADGroup -Filter { Name -like '*'}
    $return  = @()

    # Parse through groups and add further encapsulated groups
    while ($groups) {
        ForEach ($group in $groups) {
            $done        = @()
            [array]$tmp_grps = (Get-ADGroup $group -Properties memberOf).memberOf
            [array]$grps     += $tmp_grps

            # Recursive parsing through the submembergroups
            while ($tmp_grps) {
                ForEach ($tmp_g in $tmp_grps) {
                    [array]$done     += $tmp_g
                    [array]$sub_grps = (Get-ADGroup $tmp_g -Properties memberOf).memberOf
                    
                    # Add submembergroups to temporary array
                    if($sub_grps) {
                        $tmp_grps += $sub_grps
                        $grps     += $sub_grps
                    }

                    # Remove already parsed groups from temporary array
                    $tmp_grps = $tmp_grps | Where-Object { $_ -ne $tmp_g -and $done -notcontains $_ }
                    $sub_grps = ''
                }
                
            }

            # Add circular nested groups to return value
            if($grps -contains $group) {
                $return   += $group
            }

            # Remove already parsed groups from array
            $groups = $groups | Where-Object {$_ -ne $group}

            # Clean up
            Remove-Variable -Name tmp_grps,done,grps,group
        }
    }

    return $return
}

Get-CircularNestedGroups
