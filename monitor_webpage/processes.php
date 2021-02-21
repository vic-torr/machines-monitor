<?php

    $connection = mysqli_connect("localhost", "vektor", "");

    // prepare sql
    $sql = "SELECT * FROM machinesdb.machines";

    // find username
    $result = mysqli_query($connection, $sql);

    //$row = mysqli_fetch_array($result);
    $row = $sql;
    // get number of rows in the table
    $rows_number = mysqli_num_rows($result);

    // create two arrays to store data
    $symbol_array = array();
    $shares_array = array();

    // fill the arrays with the rows data of stocks
    for ($i = 0; $i<$rows_number; $i++ )
    {
        $row = mysqli_fetch_array($result);
        $mac_array[$i] = $row["mac_addr"];
        $testing[$i] = $row["need_testing"];
        $is_up[$i] = $row["is_up"];
        $ip[$i] = $row["ip"];
        $name_array[$i] = $row["host_name"];
        $up_array[$i] = $row["is_up"];
        $cpu_array[$i] = $row["cpu"];
        $mem_array[$i] = $row["memory"];

    }
    


?>

<!DOCTYPE html>

<html>

  <head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
    <link href="css/styles.css" rel="stylesheet" type="text/css">
    <title>Process monitor</title>
  </head>

  <body>


    <div id="middle">  

 

        <h3>Process</h3>


        <table style =" border-spacing: 18px; clear:both;">
            <tr>
                <th>MAC</th>      
                <th>Testing</th>        
                <th>power on  </th>          
                <th>IP</th>         
                <th>host name </th>        
                <th>CPU</th>       
                <th>Memory</th>
                <th>Users</th>       
                <th>Processes</th>       
         
            </tr>
            <?php for ($i = 0; $i < $rows_number; $i++) : ?>
            
            <tr>
                <td> <?= $mac_array[$i]; ?> </td>
                <td> <?= $testing[$i]; ?> </td>
                <td> <?= $is_up[$i]; ?> </td>
                <td> <?= $ip[$i]; ?> </td>
                <td> <?= $name_array[$i]; ?> </td>
                <td> <?= $cpu_array[$i]; ?> </td>
                <td> <?= $mem_array[$i]; ?> </td>
            </tr>

            <?php endfor ?>
        </table>
    </div>

  </body>

</html>
