# Formula: spring festival couplet

In [Taiwan](https://www.google.com.tw/maps?q=taiwan&biw=1707&bih=817&dpr=1.13&um=1&ie=UTF-8&sa=X&ved=0ahUKEwjQ1e2JwZLVAhVEu7wKHa_xCWkQ_AUICygC), `春` means spring and we hang couplets with the word around the house during the lunar new year.

Try to search google for the following formula:

    x^4+y^4+100/(x^4+(2y-2)^4+(2y-1)^2)+100/(x^4+(2y+2)^4+(2y+1)^2)-1/((y+3)^4+(x/15)^4)-1/((y+4)^4+(x/15)^4)-1/((y+5)^4+(x/15)^4)-1/(4(x+y+4)^4+((x-y+1)/5)^4)-100^16/(((x-4)^2+(y+5)^2-13)^2+((x-19)^2+(y+12)^2-400)^2)^16-25 

I found this amazing formula on "[如何用方程式寫春聯](http://pansci.asia/archives/75693)" and tried to made an printable version. The function in OpenSCAD is: 

    function f(x, y) = pow(x, 4) + pow(y, 4) + 100 / (pow(x, 4) + pow(2 * y - 2, 4) + pow(2 * y - 1, 2)) + 100 / (pow(x, 4) + pow(2 * y + 2, 4) + pow(2 * y + 1, 2)) - 1 / (pow(y + 3, 4) + pow(x / 15, 4)) - 1 / (pow(y + 4, 4) + pow(x / 15, 4)) - 1 / (pow(y + 5, 4) + pow(x / 15, 4)) - 1 / (4 * pow((x + y + 4), 4) + pow((x - y + 1) / 5, 4)) - pow(100, 16) / pow((pow(pow(x - 4, 2) + pow(y + 5, 2) - 13, 2) + pow(pow(x - 19, 2) + pow(y + 12, 2) - 400, 2)), 16) - 25;



![Formula: spring festival couplet](https://thingiverse-production-new.s3.amazonaws.com/renders/4f/31/9f/68/88/c8e98edd243f0f789b618e29f96b2070_preview_featured.jpg)