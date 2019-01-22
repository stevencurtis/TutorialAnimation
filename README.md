# TutorialAnimation
A tutorial-type animation where user scrolls through a UIPageViewController and pages fade in and out.

# Why is it interesting

There are two background images, and the alpha is changed as you scroll the UIPageViewController

This is placed in a mask that enables the view to be clipped into a circle.

When the scroll view is moved, the alpha is changed for the mask. However, changing the alpha of the mask would also change the alpha of the embedded image. Therefore a new background mask is used (which always has an alpha of 1.0), and by definition this colour cannot be clear.

Because there are three 

<p align="center">
  <img src="https://github.com/stevencurtis/TutorialAnimation/blob/master/Circles.png" width="" height="">
</p>

