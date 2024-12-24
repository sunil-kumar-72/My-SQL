-- Cross Sell Target
select * from individual_budgetscsv;
select sum(cross_sell_budget) as Cross_Sell_Target from individual_budgetscsv;
-- Cross Sell Achievement
select * from brokerage_csv;
select * from feescsv;
SELECT (SELECT Round(SUM(amount),2) FROM brokerage_csv where income_class="Cross Sell") AS brokerage_cross_sell_total, (SELECT Round(SUM(amount),2) FROM feescsv where income_class="Cross Sell") AS fees_cross_sell_total, Round((SELECT SUM(amount) FROM brokerage_csv)+(SELECT SUM(amount) FROM feescsv),2) AS total_cross_sell_amount;
SELECT (SELECT Round(SUM(amount)/1000000,2) FROM brokerage_csv where income_class="Cross Sell") AS brokerage_cross_sell_total, (SELECT Round(SUM(amount)/1000000,2) FROM feescsv where income_class="Cross Sell") AS fees_cross_sell_total, Round((SELECT SUM(amount) FROM brokerage_csv)+(SELECT SUM(amount) FROM feescsv),2)/1000000 AS total_cross_sell_amount;
SELECT CONCAT(ROUND((SELECT SUM(amount) FROM brokerage_csv WHERE income_class="Cross Sell")/1000000,0),'M') AS brokerage_cross_sell_total, CONCAT(ROUND((SELECT SUM(amount) FROM feescsv WHERE income_class="Cross Sell")/1000000,0),'M') AS fees_cross_sell_total, CONCAT(ROUND(((SELECT SUM(amount) FROM brokerage_csv)+(SELECT SUM(amount) FROM feescsv))/1000000,0),'M') AS Cross_Sell_Achvt;
-- Cross Sell Invoice
select * from invoicecsv;
select concat(sum(Amount)/1000000,"M") as Cross_Sell_invoice from invoicecsv where income_class="Cross Sell";
-- New Target
select * from individual_budgetscsv;
select Concat(sum(New_Budget)/1000000,"M") as New_Target from individual_budgetscsv;
-- New Achievement
select * from brokerage_csv;
select * from feescsv;
SELECT CONCAT(ROUND((SELECT SUM(amount) FROM brokerage_csv WHERE income_class="New")/1000000,2),'M') AS brokerage_cross_sell_total, CONCAT(ROUND((SELECT SUM(amount) FROM feescsv WHERE income_class="New")/1000000,2),'M') AS fees_cross_sell_total, CONCAT(ROUND(((SELECT SUM(amount) FROM brokerage_csv)+(SELECT SUM(amount) FROM feescsv))/1000000,2),'M') AS New_Achvt;
-- New Invoice
select * from invoicecsv;
select concat(Round(sum(Amount)/1000000,2),"M") as New_invoice from invoicecsv where income_class="New";
-- Renewal Target
select * from individual_budgetscsv;
select Concat(sum(Renewal_Budget)/1000000,"M") as Renewal_Target from individual_budgetscsv;
-- Renewal Achvt
select * from brokerage_csv;
select * from feescsv;
SELECT CONCAT(ROUND((SELECT SUM(amount) FROM brokerage_csv WHERE income_class="Renewal")/1000000,2),'M') AS brokerage_renewal_total, CONCAT(ROUND((SELECT SUM(amount) FROM feescsv WHERE income_class="Renewal")/1000000,2),'M') AS fees_renewal_total, CONCAT(ROUND(((SELECT SUM(amount) FROM brokerage_csv WHERE income_class="Renewal")+(SELECT SUM(amount) FROM feescsv WHERE income_class="Renewal"))/1000000,2),'M') AS Renewal_Achvt;
-- Renewal invoice
select * from invoicecsv;
select concat(Round(sum(Amount)/1000000,2),"M") as Renewal_invoice from invoicecsv where income_class="Renewal";
-- Cross Sell Plcd Acheivement %
select * from brokerage_csv;
select * from individual_budgetscsv;
select * from feescsv;
SELECT ROUND(((SELECT SUM(amount) FROM brokerage_csv WHERE income_class="Cross Sell")+(SELECT SUM(amount) FROM feescsv WHERE income_class="Cross Sell"))/(SELECT SUM(cross_sell_budget) FROM individual_budgetscsv)*100,2) AS Cross_Sell_Achievement_Percentage;
-- Cross Sell invoice Plcd Achvmnt %
SELECT ROUND((SELECT SUM(amount) FROM invoicecsv WHERE income_class="Cross Sell")/(SELECT SUM(cross_sell_budget) FROM individual_budgetscsv)*100,2) AS Cross_Sell_Invoice_Placed_Achievement_Percentage;
-- New Plcd Achievement %
SELECT ROUND(((SELECT SUM(amount) FROM brokerage_csv WHERE income_class="New")+(SELECT SUM(amount) FROM feescsv WHERE income_class="New"))/(SELECT SUM(new_budget) FROM individual_budgetscsv)*100,2) AS New_Achievement_Percentage;
-- New Invoice Achievement %
SELECT ROUND((SELECT SUM(amount) FROM invoicecsv WHERE income_class="New")/(SELECT SUM(new_budget) FROM individual_budgetscsv)*100,2) AS New_Invoice_Achievement_Percentage;
-- Renewal Plcd Achievement %
SELECT ROUND(((SELECT SUM(amount) FROM brokerage_csv WHERE income_class="Renewal")+(SELECT SUM(amount) FROM feescsv WHERE income_class="Renewal"))/(SELECT SUM(renewal_budget) FROM individual_budgetscsv)*100,2) AS Renewal_Achievement_Percentage;
-- Renewal Invoice Achievement %
SELECT CONCAT(ROUND((SELECT SUM(amount) FROM invoicecsv WHERE income_class="Renewal")/(SELECT SUM(renewal_budget) FROM individual_budgetscsv)*100,2),'%') AS Renewal_Invoice_Achievement_Percentage;
-- Yearly Meeting Count
select * from meetingcsv;
select year(STR_TO_DATE(meeting_date,'%d/%m/%Y')) as Year,count(*) as Count_of_Meetings from meetingcsv group by Year;
-- Total Open Opportunities
select * from opportunitycsv;
select stage,count(revenue_amount) as Total_Open_Opportunities from opportunitycsv where stage in("Qualify Opportunity","Propose Solution") group by stage order by Total_Open_Opportunities desc;
-- Total Opportunities
select * from opportunitycsv;
select stage,count(revenue_amount) as Total_Opportunities from opportunitycsv group by stage order by Total_Opportunities desc;
-- No of Meeting By Account Executive
select * from meetingcsv;
select Account_Executive,count(meeting_date) as Total_Meeting_Count from meetingcsv group by Account_Executive order by Total_Meeting_Count desc limit 10;
-- No of Voice By Account Executive
select * from invoicecsv;
select Account_Executive,count(invoice_number) as Total_Count from invoicecsv group by Account_Executive order by Total_Count desc limit 8;
-- Top 4 -Oppty By Revenue
select * from opportunitycsv;
select opportunity_name,sum(revenue_amount) as Total_Amount from opportunitycsv where stage in("Qualify Opportunity","Negotiate","Propose Solution") group by opportunity_name order by Total_Amount desc limit 4;
-- Stage Funnel By Revenue
select * from opportunitycsv;
select stage,sum(revenue_amount) as Total_Amount from opportunitycsv group by stage order by Total_Amount desc;
-- Oppty Product Distributon
select * from opportunitycsv;
select product_group,count(opportunity_id) as Total_Count from opportunitycsv group by product_group order by Total_Count desc limit 8;
-- Top 4 -Open Oppty By Revenue
select * from opportunitycsv;
select opportunity_name,sum(revenue_amount) as Total_amount from opportunitycsv where stage in("Qualify Opportunity","Propose Solution") group by opportunity_name order by Total_Amount desc limit 4;
