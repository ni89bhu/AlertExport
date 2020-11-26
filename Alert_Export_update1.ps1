##############################################################################################################
#>>Description                                                                                                #
#This script helps in exporting incident data from database.                                                  #
#>>Input                                                                                                      #
#Change the output path, sql instance name and evaluation duration.                                           #
#>>Output                                                                                                     #
#CSV will be generated in the output path        .                                                            #
##############################################################################################################
$outputpath = "D:\ElasticTest"#change output path#
$instance = "ETPVMDFHNUARX02\SQLEXPRESS"#change sql instance#
$duration = "1"#change duration in days#

#############################################################################################################
$date =get-date -Format "MMddyyyy_HHmmss"

$query = "declare @Approval_date1 datetime
set @Approval_date1 =getdate()
declare @Approval_date2 datetime
set @Approval_date2 =dateadd(day,-$duration,getdate())
SELECT [Alert_Name]
      ,[LogTime]
      ,[Event_User]
      ,[Event_Description]
      ,[Risk]
      ,[Computer]
      ,[Port]
  FROM [EventTrackerAlerts].[dbo].[wvw_IncidentData]
  WHERE LogTime between @Approval_date2 and @Approval_date1
  ORDER BY LogTime DESC"

$output = Invoke-Sqlcmd -ServerInstance "$instance" -Database "EventTrackerAlerts" -Query $query

#############################################################################################################
$fname = "Alerts_Export_{0}" -f $date
$output | Export-Csv "$outputpath\$fname.csv" -NoTypeInformation

#############################################################################################################