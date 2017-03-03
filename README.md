# CSCE-643-P2
Please manually select corresponding 20 point pairs across these two images. Compute Homography matrix H using the following methods
1.	H matrix computed using  DLT (20pts)
2.	H matrix computed using nomalized DLT. In your report, please tell me how do you normalize the images. (20pts)
3.	H matrix computed using MLE (modifying DLT's objective function to apply 	MLE,. Note: you can use Sampson Error instead of reprojection error) (40 pts)
Please compose panorama using the H you obtained for each cases. Again, you can use opencv or matlab functions to reproject image.

Peer Grading (20 pts).

Challenge 2: Implement RANSAC (Dot not using any existing RANSAC functions  embedded in existing libraries). In you program, please make sure that you can randomly generate N false corresponding points for both images. Mix those points with the 20 points that you have in previous step. Using the N+20 points, repeatedly perform RANSAC on those points for increasing N size. For example, you can try N=20, 200, 1000, 2000, and 5000.... Report your findings on RANSAC time and inlier detection accuracy. Tell me when RANSAC would fail and provide probability analysis on your findings.
