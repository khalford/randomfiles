<?php
try {
  $db = new PDO("mysql:host=localhost;dbname=githubstats", oxg98278, "password");
  echo "<h2>Most Commits SCD-Openstack-Utils</h2><ol>";
  foreach($db->query("SELECT username,no_commits FROM commit_stats") as $row) {
          echo "<li>".$row['username']."'s ".'commits: '.$row['no_commits']."</li>";
  }
  echo "</ol>";
} catch (PDOException $e) {
    print "Error!: " . $e->getMessage() . "<br/>";
    die();
}
