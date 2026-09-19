---
title: CV
nav:
  order: 4
  tooltip: Curriculum Vitae
---

# {% include icon.html icon="fa-solid fa-file-lines" %} CV

{% assign cv_member = site.members
  | where: "slug", "arindam-raj"
  | first
%}

{% capture cv_portrait %}

{% include portrait.html lookup="arindam-raj" %}

<div>
  {% for link in cv_member.links %}
    {% assign key = link[0] %}
    {% assign value = link[1] %}
    {% include button.html type=key link=value style="bare" %}<br>
  {% endfor %}
</div>

{% endcapture %}

{% include float.html content=cv_portrait %}

{{ cv_member.content | markdownify }}

{% include float.html clear=true %}

<p>
  <a href="{{ '/cv/ArindamCV_for_website.pdf' | relative_url }}"
     target="_blank"
     rel="noopener">
    Open CV (PDF)
  </a>
</p>

<iframe
  src="{{ '/cv/ArindamCV_for_website.pdf' | relative_url }}"
  title="Arindam Raj — Curriculum Vitae"
  width="100%"
  height="800"
  style="border: none;">
</iframe>

<!--
---
title: CV
nav:
  order: 4
  tooltip: Curriculum Vitae
---
# {% include icon.html icon="fa-solid fa-file-lines" %}CV
<!-- # {% include icon.html icon="fa-solid fa-feather-pointed" %}CV-->
<!--<iframe src="/arindam-lab-website/cv/ArindamCV_for_website.pdf" width="100%" height="800px" style="border: none;">
    This browser does not support embedded PDFs. <a href="/arindam-lab-website/blog/ArindamCV.pdf">Click here to download the PDF</a>.
</iframe>
-->
<!--
<p>
  <a href="{{ '/cv/ArindamCV_for_website.pdf' | relative_url }}"
     target="_blank" rel="noopener">
    Open CV (PDF)
  </a>
</p>

<iframe
  src="{{ '/cv/ArindamCV_for_website.pdf' | relative_url }}"
  title="Arindam Raj — Curriculum Vitae"
  width="100%"
  height="800px"
  style="border: none;">
</iframe>
-->
