Write-Host "======================================================================================================================"
Write-Host "========== eTASK Git Hook ============================================================================================"
Write-Host "======================================================================================================================"

$CommitMessageFile=$args[0]
Write-Host "Git commit message file: "$CommitMessageFile 

$CommitMessage = Get-Content -Path $CommitMessageFile
Write-Host "Git commit message: "$CommitMessage 

#########################
####### Functions #######
#########################
Function CheckBranchName([int]$zahl) { 

    # Find current branch name
    # $BRANCH_NAME=$(git symbolic-ref --short HEAD)
    # if [[ -z "$BRANCH_NAME" ]]; then
    #     echo "No branch name... "; exit 1
    # fi
    
    # Extract issue id from branch name
    # $ISSUE_ID=$(echo "$BRANCH_NAME" | grep -o -E "$REGEX_ISSUE_ID")
    
    # echo "$ISSUE_ID"': '$(cat "$1") > "$1"


    if ($zahl -eq 0) {
        return $true
    }
    else {
        Write-Host "Dieser Commit kann nicht eingecheckt werden."
        Write-Host "Der Name des Branches ist falsch."
        Write-Host "Bitte benenne Deinen Branch korrekt und versuche es dann nochmal. Danke!"
        return $false
    }
}

Function CheckJiraCode([string]$CommitMessage) { 

    # Diese Check prüft die Commit-Message. Der reguläre Ausdruck
    # unten sucht nach JIRA-Codes. Der Code wird
    # wird aus dem Namen des Zweigs extrahiert

    #$CommitMessage = "IT-123 : Dies ist die Message in a bottle"
    #$REGEX_ISSUE_ID="FM (1)"

    $ValidJiraProjects = {'FM','KP','IT','FO'}
    
    # Regel 1: Erste beiden Zeichen müssen eines der validen Projektkürzel sein
    # Regel 2: Dann folgt ein Bindestrich
    # Regel 3: Dann folgt eine positive Interger-Zahl
    # Regel 4: Dann darf kein Zeilenumbruch kommen
    # Regel 5: Dann muss ein Leerzeichen kommen

    $REGEX_ISSUE_ID="(KP|IT|FO|FM)-\d+[^\S\r\n]"

    Write-Host "Checking the commit message: "$CommitMessage 
    Write-Host "against this rexex: "$REGEX_ISSUE_ID 

    $Regex_Result = Select-String $REGEX_ISSUE_ID -inputobject $CommitMessage

    if ($null -eq $Regex_Result)
    {
        Write-Host "Dieser Commit kann nicht eingecheckt werden."
        Write-Host "Die Commit-Message ist nicht korrekt. Es sind Jira-Referenzen in dieser Form erlaubt: 'FM-123 : Mein Commit Text'"
        Write-Host "Diese Projekte aus Jira werden unterstuetzt:"$ValidJiraProjects
        Write-Host "Bitte referenziere einen Jira Issue direkt am Anfang der Commit-Message und versuche es dann nochmal. Danke!"
        return $false
    }
    else {
        Write-Host "Extracted ISSUE_ID: "$Regex_Result.Matches[0]
        return $true
    }
} 


#########################
###### The script #######
#########################

$exitCode = 0;

#$changes = Invoke-Expression("git diff --name-only")
#Write-Host "Changed files: "$changes

$CheckBranchNameResult = CheckBranchName(0)
if ($CheckBranchNameResult -eq $false)
{
    $exitCode = 1;
}

$CheckJiraCodeResult = CheckJiraCode($CommitMessage)
if ($CheckJiraCodeResult -eq $false)
{
    $exitCode = 1;
}

if ($exitCode -eq 0)
{
    Write-Host "Dieser Commit ist ok. Vielen Dank fuer Deinen Beitrag zu eTASK!"
}

Write-Host "ExitCode = "$exitcode
Write-Host "======================================================================================================================"
Exit $exitcode