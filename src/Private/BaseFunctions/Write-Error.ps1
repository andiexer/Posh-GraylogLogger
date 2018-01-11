function Global:Write-Error {
    [CmdletBinding(DefaultParameterSetName='NoException', HelpUri='https://go.microsoft.com/fwlink/?LinkID=113425', RemotingCapability='None')]
    param(
        [Parameter(ParameterSetName='WithException', Mandatory=$true)]
        [System.Exception]
        ${Exception},
    
        [Parameter(ParameterSetName='NoException', Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [Parameter(ParameterSetName='WithException')]
        [Alias('Msg')]
        [AllowNull()]
        [AllowEmptyString()]
        [string]
        ${Message},
    
        [Parameter(ParameterSetName='ErrorRecord', Mandatory=$true)]
        [System.Management.Automation.ErrorRecord]
        ${ErrorRecord},
    
        [Parameter(ParameterSetName='NoException')]
        [Parameter(ParameterSetName='WithException')]
        [System.Management.Automation.ErrorCategory]
        ${Category},
    
        [Parameter(ParameterSetName='NoException')]
        [Parameter(ParameterSetName='WithException')]
        [string]
        ${ErrorId},
    
        [Parameter(ParameterSetName='NoException')]
        [Parameter(ParameterSetName='WithException')]
        [System.Object]
        ${TargetObject},
    
        [string]
        ${RecommendedAction},
    
        [Alias('Activity')]
        [string]
        ${CategoryActivity},
    
        [Alias('Reason')]
        [string]
        ${CategoryReason},
    
        [Alias('TargetName')]
        [string]
        ${CategoryTargetName},
    
        [Alias('TargetType')]
        [string]
        ${CategoryTargetType})
    
    begin
    {
        try {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Error', [System.Management.Automation.CommandTypes]::Cmdlet)
            $scriptCmd = {& $wrappedCmd @PSBoundParameters }
            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($PSCmdlet)
        } catch {
            throw
        }
    }
    
    process
    {
        try {
            $steppablePipeline.Process($_)
            Write-GLLog -LogLevel Error -LogText $Message
        } catch {
            throw
        }
    }
    
    end
    {
        try {
            $steppablePipeline.End()
        } catch {
            throw
        }
    }
    <#
    
    .ForwardHelpTargetName Microsoft.PowerShell.Utility\Write-Error
    .ForwardHelpCategory Cmdlet
    
    #>
}