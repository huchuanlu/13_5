This code is a MATLAB implementation of the tracking algorithm described in TIP 2012 paper 
        "Online Object Tracking with Sparse Prototypes" 
               by Dong Wang, Huchuan Lu and Ming-Hsuan Yang.
***********************************************************************
The code runs on Windows XP with MATLAB R2009b.

-Main MATLAB files:
  	--trackparam.m : 		load a dataset and sets parameters up
  	--demo.m : 	    		run tracking
	  Edit the variable 'title' in demo.m for different sequences, and run demo.m.
	--dispalyResults.m		display and save all tracker's results 
					(the results are saved under the "Dump" folder)
	--displayComparsion.m      display comparsion plots of all trackers 

-"Tracker" Folder:	the matlab codes of the proposed tracker.

-"Evaluation" Folder:
	--Evalution tools used in our paper

-"Data" Folder:	Datasets available
	--'Occlusion1'	From [1]
	--'Occlusion2'	From [3]
	--'Caviar1'		From [7]
	--'Caviar2'		From [7]
	--'Car4'		From [6]
	--'Singer1'		From [5]
	--'DavidIndoor'	From [6]
	--'Car11'		From [6]
	--'Deer'		From [5]
	--'Jumping'		From [4]
	--'Lemming'		From [8]
	--'Cliffbar'		From [3]
	--'Girl'		From [5]
	--'DavidOutdoor'
	--'Stone'


-"Results" Folder:	Ground Truth & Other Tracker's Results
	--xxxx_gt.mat
	--xxxx_srpca_rs.mat
	--xxxx_frag_rs.mat		[1]
	--xxxx_l1_rs.mat		[2]
	--xxxx_mil_rs.mat		[3]
	--xxxx_pn_rs.mat		[4]
	--xxxx_vtd_rs.mat		[5]
	--xxxx_pca_rs.mat		[6]

	*Note: 
	a. "xxxx" stands for the video name.
	b. Two types of ground truth and results:
		Centers: the center location of the tracked object
		Corners: the corners of the tracked object
			  [x_top_left  x_top_right x_bottem_right x_bottem_left x_top_left
                       y_top_left  y_top_right y_bottem_right y_bottem_left y_top_left]

References:
[1] A. Adam, E. Rivlin, and I. Shimshoni. Robust fragments-based tracking using the integral histogram. In Proceedings of IEEE Conference on Computer Vision and Pattern Recognition, pages 798每805, 2006.
[2] X. Mei and H. Ling. Robust visual tracking using L1 minimization. In Proceedings of the IEEE International Conference on Computer Vision, pages 1436每1443, 2009.
[3] B. Babenko, M.-H. Yang, and S. Belongie. Visual tracking with online multiple instance learning. In Proceedings of IEEE Conference on Computer Vision and Pattern Recognition, pages 983每990, 2009.
[4] Z. Kalal, J. Matas, and K. Mikolajczyk. P-N learning: Bootstrapping binary classifiers by structural constraints. In Proceedings of IEEE Conference on Computer Vision and Pattern Recognition, pages 49每56, 2010.
[5] J. Kwon and K. M. Lee. Visual tracking decomposition. In Proceedings of IEEE Conference on Computer Vision and Pattern Recognition, pages 1269每1276, 2010.
[6] D. Ross, J. Lim, R.-S. Lin, and M.-H. Yang. Incremental learning for robust visual tracking. International Journal of Computer Vision, 77(1-3):125每141, 2008.
[7] CAVIAR. http://groups.inf.ed.ac.uk/vision/CAVIAR/CAVIARDATA1/.
[8] J. Santner, C. Leistner, A. Saffari, T. Pock, and H. Bischof. PROST: Parallel robust online simple tracking. In Proceedings of IEEE Conference on Computer Vision and Pattern Recognition, pages 723每730, 2010.

***********************************************************************
Thanks to Jongwoo Lim and David Ross. The affine transformation part is derived from their code for "Incremental Learning for Robust Visual Tracking" (IJCV 2008) by David Ross, Jongwoo Lim, Ruei-Sung Lin and Ming-Hsuan Yang.
***********************************************************************
This is the version 1 of the distribution. We appreciate any comments/suggestions. For more quetions, please contact us at wdice@mail.dlut.edu.cn or wangdong.ice@gmail.com or lhchuan@dlut.edu.cn or mhyang@ucmerced.edu.
	
Dong Wang, Huchuan Lu and Ming-Hsuan Yang 
June 2012