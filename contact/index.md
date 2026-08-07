---
title: Contact
nav:
  order: 5
  tooltip: Email, address, and location
---

# {% include icon.html icon="fa-regular fa-envelope" %}Contact

Feel free to reach out for any queries, discussions, or collaborations!

{%
  include button.html
  type="email"
  text="arindam.raj@northwestern.com"
  link="arindam.raj@northwestern.com"
%}
{%
  include button.html
  type="phone"
  text="(123) 456-7890"
  link="+1-123-456-7890"
%}
{%
  include button.html
  type="address"
  tooltip="Our location on Google Maps for easy navigation"
  link="https://www.google.com/maps/place/Patrick+G.+and+Shirley+W.+Ryan+Hall,+2190+Campus+Dr,+Evanston,+IL+60208/@42.0568329,-87.6770946,17z/data=!3m1!4b1!4m6!3m5!1s0x880fda9e5bc4df91:0xf6386e5bebb00cb4!8m2!3d42.0568289!4d-87.6745197!16s%2Fg%2F12hmymrnj?entry=ttu&g_ep=EgoyMDI2MDcyOS4wIKXMDSoASAFQAw%3D%3D"
%}

{% include section.html %}

{% capture col1 %}

{%
  include figure.html
  image="images/NU_postdoc.jpg"
  caption="Currently at Northwestern University"
  style="aspect-ratio: 16 / 9; object-fit: cover; width: 100%;"
%}

{% endcapture %}

{% capture col2 %}

{%
  include figure.html
  image="images/yale_phd.jpg"
  caption="via Yale University"
  style="aspect-ratio: 16 / 9; object-fit: cover; width: 100%;"
%}

{% endcapture %}

{% capture col3 %}

{%
  include figure.html
  image="images/iit_undergrad.jpg"
  caption="and Indian Institute of Technology, Kanpur"
  style="aspect-ratio: 16 / 9; object-fit: cover; width: 100%;"
%}

{% endcapture %}

{% include cols.html col1=col1 col2=col2 col3=col3 %}

{% include section.html dark=true %}

{% capture col1 %}
<p>
  <a href="https://en.wikipedia.org/wiki/File:Northwestern_University_Aerial.jpg">"Northwestern University Aerial"</a> by Joshua Sukoff is licensed under <a href="https://creativecommons.org/licenses/by-sa/4.0/">CC BY-SA 4.0</a>.
</p>

{% endcapture %}

{% capture col2 %}
<p>
  <a href="https://jenikirbyhistory.getarchive.net/media/yale-university-landscape-universities-nature-landscapes-e3b4d0">"Yale University Landscape"</a> via Pixaby is marked with <a href="https://web.archive.org/web/20170727004823/https://pixabay.com/en/service/license/"> Creative Commons CC0 with additional limitations</a>.
</p>

{% endcapture %}

{% capture col3 %}
<p>
  <a href="https://en.wikipedia.org/wiki/File:Indian_Institute_of_Technology_Kanpur.jpg">"Night View of IIT Kanpur"</a> by NiteshSingh6789 via Wikimedia Commons is marked with <a href="https://creativecommons.org/publicdomain/zero/1.0/deed.en">CC0 1.0</a>.
</p>

{% endcapture %}

{% include cols.html col1=col1 col2=col2 col3=col3 %}
