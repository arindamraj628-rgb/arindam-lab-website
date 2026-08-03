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
  image="contact/NU1_postdoc.jpg"
  caption="Currently at Northwestern University"
%}

{% endcapture %}

{% capture col2 %}

{%
  include figure.html
  image="contact/yale_phd1.jpg"
  caption="via Yale University"
%}

{% endcapture %}

{% include cols.html col1=col1 col2=col2 %}

{% include section.html dark=true %}

{% capture col1 %}

{% endcapture %}

{% capture col2 %}

{% endcapture %}

{% capture col3 %}

{% endcapture %}

{% include cols.html col1=col1 col2=col2 col3=col3 %}
