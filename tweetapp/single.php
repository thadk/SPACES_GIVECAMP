<?php
/**
 *	@package WordPress
 *	@subpackage Grid_Focus
 */
get_header();
?>
<div id="filler" class="fix">
	<div id="mainColumn" class="fix"><a name="main"></a>
		<?php if (have_posts()) : while (have_posts()) : the_post(); ?>
		<div id="post-<?php the_ID(); ?>" class="post">
			<div class="postMeta fix">
				<p class="container">
					<span class="date"><?php the_time('M j, Y') ?><?php edit_post_link(' (Edit)', '', ''); ?></span>
				</p>
			</div>
			<h2><a href="<?php the_permalink() ?>" title="<?php the_title(); ?>"><?php the_title() ?></a></h2>
			<div class="entry">
				<?php the_content('<p>Read the rest of this entry &raquo;</p>'); ?>

<style>
.tweetapp .entry{
float: left;
padding-right: 45px;
padding-top: 10px;
text-align: center;
}

</style>
<?php 

//Thad Kerosky, Cleveland Give Camp, 19 July 2010.
function drawTwitPictures($contest='SPC099') {
	global $wpdb;
	
	//http://codex.wordpress.org/Function_Reference/wpdb_Class
	$sql = "SELECT twituser,tweetid,content,SPChashtag FROM tweetapp_submissions WHERE SPChashtag='$contest'";
	$twitPicImages = $wpdb->get_results($sql, ARRAY_A);
	
	foreach ($twitPicImages as $row) {
		//the database returns the raw tweet's API call contents
		//lets decode it.
		$submission = json_decode($row['content'],true); 

		//now clean it up for display
		$pattern = "/http:\/\/(www\.)?twitpic\.com\/([^ ]+)/";
		$matches = array();
		preg_match($pattern, $submission['text'], $matches);

		//first link the whole div
		echo "<a href='http://twitpic.com/".$matches[2]."'><div class='entry'>";
		if (!empty($matches)) {
			//make the img tag
			echo "<img src='http://twitpic.com/show/thumb/".$matches[2]."'>";
		}
		//clean up the comment:
		$comment = preg_replace("/http:\/\/[^ ]+/","",$submission['text']);
		$comment = preg_replace("/#SPC[0-9]{3}/","",$comment);
		$comment = preg_replace("/@spacesgallery/","",$comment);
		echo '<h4>"'.trim($comment)."\"<h4><span>".$row['twituser']."</span>";
		echo "</div></a>";
	}
}

	foreach((get_the_category()) as $category) { 
		if ($category->cat_ID == 460) {
			echo "<div class='tweetapp'>";

			//We need to get the contest ID from permalink
			$permalinkArray = explode('/',get_permalink());
			$ThisContest = $permalinkArray[5]; //fifth part of the URL

			drawTwitPictures($ThisContest); //draw the submissions
			echo "</div>";
		} 
	}
?>
			</div>
			<div class="entry meta">
				<p><span class="highlight">Category:</span> <?php the_category(', ') ?></p>
				<p><span class="highlight">Tagged:</span> <?php the_tags( '', ', ', ''); ?></p>
				<p><span class="highlight">the_ID:</span> 
				<?php 
foreach((get_the_category()) as $category) { 
    echo $category->cat_ID . ' '; 
} ?></p>
			</div>
		</div>
		<div id="commentsContainer">
			<?php comments_template(); ?>
		</div>
		<?php endwhile; else: ?>
		<div class="post">
			<h2>No matching results</h2>
			<div class="entry">
				<p>You seem to have found a mis-linked page or search query with no associated results. Please trying your search again. If you feel that you should be staring at something a little more concrete, feel free to email the author of this site or browse the archives.</p>
			</div>
		</div>
		<?php endif; ?>
	</div>
	<?php include (TEMPLATEPATH . '/second.column.post.php'); ?>
	<?php include (TEMPLATEPATH . '/third.column.shared.php'); ?>
</div>
<?php get_footer(); ?>

