<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>title</title>
    <script src="ECharts/echarts.min.js"></script>
    <script src="jquery/jquery-1.11.1-min.js"></script>
    <script>

        $(function () {

            getCharts();

        })

        function getCharts() {

            /*

                发出ajax请求，取得数据
                    echarts插件需要两种数据：
                    total:100
                    data:[

                        {value: 数量, name: '统计项'},
                        {value: 160, name: '07成交'},

                    ]



             */

            $.ajax({

                url : "workbench/transaction/getCharts.do",
                type : "get",
                dataType : "json",
                success : function (data) {

                    /*

                        data
                            {"total":100,"dataList":[{"value":100,"name":"07xxx"},{"value":100,"name":"07xxx"},{"value":100,"name":"07xxx"}]}

                     */

                    //数据拿到后，开始画图
                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));

                    // 指定图表的配置项和数据
                    var option = {
                        title: {
                            text: '交易漏斗图',
                            subtext: '统计交易阶段数量的漏斗图'
                        },

                        series: [
                            {
                                name:'漏斗图',
                                type:'funnel',
                                left: '10%',
                                top: 60,
                                //x2: 80,
                                bottom: 60,
                                width: '80%',
                                // height: {totalHeight} - y - y2,
                                min: 0,
                                max: data.total,
                                minSize: '0%',
                                maxSize: '100%',
                                sort: 'descending',
                                gap: 2,
                                label: {
                                    show: true,
                                    position: 'inside'
                                },
                                labelLine: {
                                    length: 10,
                                    lineStyle: {
                                        width: 1,
                                        type: 'solid'
                                    }
                                },
                                itemStyle: {
                                    borderColor: '#fff',
                                    borderWidth: 1
                                },
                                emphasis: {
                                    label: {
                                        fontSize: 20
                                    }
                                },
                                data: data.dataList
                                    /*
                                    这里明显是List<Map<String,Object>>数据类型
                                    [
                                    {value: 160, name: '07成交'},
                                    {value: 40, name: '01资质审查'},
                                    {value: 20, name: '08丢失的线索'},
                                    {value: 8, name: '09因竞争丢失关闭'},
                                    {value: 100, name: '02需求分析'},
                                    {value: 90, name: '05提案/报价'},
                                    {value: 50, name: '03价值建议'},
                                    {value: 99, name: '04确定决策者'},
                                    {value: 58, name: '06谈判/复审'},
                                ]*/
                            }
                        ]
                    };

                    //使用刚指定的配置项和数据显示图表。
                    //画笔.画(图)
                    myChart.setOption(option);

                }

            })






        }



    </script>
</head>
<body>

    <!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
    <div id="main" style="width: 700px;height:400px;"></div>

</body>
</html>




































