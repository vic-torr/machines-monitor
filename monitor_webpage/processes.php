<?php

    $connection = mysqli_connect("localhost", "vektor", "");

    // prepare sql
    $sql = "SELECT * FROM machinesdb.machines.processes";

    // find username
    $result = mysqli_query($connection, "SELECT * FROM machinesdb.processes");

    // get number of rows in the table
    $rows_number = mysqli_num_rows($result);

    // fill the arrays with the rows data of stocks
    for ($i = 0; $i<$rows_number; $i++ )
    {
        $row = mysqli_fetch_array($result);
        $pid[$i] = $row["pid"];
        $process_name[$i] = $row["process_name"];
        $cpu[$i] = $row["cpu"];
        $ram[$i] = $row["ram"];
        $process_time[$i] = $row["process_time"];
        $user_name[$i] = $row["user_name"];
        $command[$i] = $row["command"];
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
                <th>PID</th>      
                <th>ProcessName</th>        
                <th>CPU  </th>          
                <th>Memory</th>         
                <th>ProcessTime </th>        
                <th>UserName</th>       
                <th>Command</th>    
                <th>Machine</th>    
            </tr>
            <?php for ($i = 0; $i < $rows_number; $i++) : ?>
            
            <tr>
                <td> <?= $pid[$i]; ?> </td>
                <td> <?= $process_name[$i]; ?> </td>
                <td> <?= $cpu[$i]; ?> </td>
                <td> <?= $ram[$i]; ?> </td>
                <td> <?= $process_time[$i]; ?> </td>
                <td> <?= $user_name[$i]; ?> </td>
                <td> <?= $command[$i]; ?> </td>
                <td>  <a href="/index.php">Machine</a> </td>
            </tr>
            <?php endfor ?>
        </table>
    </div>

  </body>

</html>
