defmodule MWSClient.ReportsTest do
  use ExUnit.Case

  alias MWSClient.Reports
  alias MWSClient.Config
  alias MWSClient.Operation

  test "it requests a report" do
    options = [report_options: "ShowSalesChannel=true", end_date: "2016-10-24T23:11:17Z", start_date: "2016-09-25T23:11:17Z"]
    result = Reports.request_report("_GET_FLAT_FILE_ORDERS_DATA_", options)
    assert result == %Operation{method: "POST",
                                params: %{"Action" => "RequestReport", 
                                 "EndDate" => "2016-10-24T23:11:17Z",
                                 "ReportOptions" => "ShowSalesChannel=true",
                                 "ReportType" => "_GET_FLAT_FILE_ORDERS_DATA_",
                                 "StartDate" => "2016-09-25T23:11:17Z", 
                                 "Version" => "2009-01-01"}, 
                                path: "/",
                                timestamp: nil}
  end

  test "it requests report list by id" do
    options = [report_request_id_list: ["50714017099"]]
    result = Reports.get_report_request_list(options) 
    assert result == %Operation{method: "POST",
                                params: %{"Action" => "GetReportRequestList",
                                          "ReportRequestIdList.Id.1" => "50714017099", 
                                          "Version" => "2009-01-01"},
                                path: "/", 
                                timestamp: nil}
  end


end