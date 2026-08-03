---
title: Team
nav:
  order: 3
  tooltip: About our team
---

# {% include icon.html icon="fa-solid fa-users" %}Team

Feel free to reach out for any queries, discussions, or collaborations!

{% include section.html %}

{% include list.html data="members" component="portrait" filter="role == 'pi'" %}
{% include list.html data="members" component="portrait" filter="role != 'pi'" %}

{% include section.html background="images/background.jpg" dark=true %}

Feel free to reach out for any queries, discussions, or collaborations!

{% include section.html %}

{% capture content %}

{% endcapture %}

{% include grid.html style="square" content=content %}
