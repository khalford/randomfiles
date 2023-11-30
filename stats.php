<?php
try {
  $db = new PDO("mysql:host=localhost;dbname=<database_name>", <username>, "password");
  echo "<h2>Most Commits SCD-Openstack-Utils</h2><ol>";
  foreach($db->query("SELECT username,no_commits FROM <table_name>") as $row) {
          echo "<li>".$row['username']."'s ".'commits: '.$row['no_commits']."</li>";
  }
  echo "</ol>";
} catch (PDOException $e) {
    print "Error!: " . $e->getMessage() . "<br/>";
    die();
}
