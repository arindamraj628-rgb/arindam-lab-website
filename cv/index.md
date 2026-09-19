---
title: CV
nav:
  order: 4
  tooltip: About Arindam Raj
---

# {% include icon.html icon="fa-solid fa-file-lines" %} CV

<style>
  .cv-profile {
    display: grid;
    grid-template-columns: 220px minmax(0, 1fr);
    gap: 40px;
    align-items: start;
  }

  .cv-sidebar {
    text-align: center;
  }

  .cv-sidebar p {
    text-align: center;
  }

  .cv-photo {
    display: block;
    width: 175px;
    aspect-ratio: 1;
    margin: 0 auto 20px;
    border-radius: 50%;
    object-fit: cover;
    object-position: 50% 0%;
    box-shadow: var(--shadow);
  }

  .cv-details {
    min-width: 0;
  }

  .cv-details > p:first-child {
    margin-top: 0;
  }

  .cv-pdf {
    display: block;
    width: 100%;
    height: 800px;
    border: none;
  }

  @media (max-width: 700px) {
    .cv-profile {
      grid-template-columns: minmax(0, 1fr);
      gap: 24px;
    }
  }
</style>

<div class="cv-profile">

  <aside class="cv-sidebar">
    <img
      class="cv-photo"
      src="{{ '/images/pic_arindam_headshot.png' | relative_url }}"
      alt="Arindam Raj"
    >

    <p>
      <strong>Arindam Raj</strong><br>
      Weinberg Family<br>
      Postdoctoral Fellow,<br>
      Northwestern University
    </p>

    <div>
      {% include button.html
        type="home-page"
        link="/"
        style="bare"
      %}
      <br>
      {% include button.html
        type="orcid"
        link="0000-0001-7277-6770"
        style="bare"
      %}
    </div>
  </aside>

  <div class="cv-details">

    <p>

    </p>

    <p>
      <strong>Current affiliation:</strong>
      <a href="https://mirkin-group.northwestern.edu/">
        Mirkin Research Group
      </a>,
      Department of Chemistry, Northwestern University
      <br>
      <strong>Previously at:</strong>
      <a href="https://www.schroerslab.com/">Schroers Lab</a>,
      Department of Mechanical Engineering &amp; Materials Science,
      Yale University
    </p>

    <p>
      <a
        href="{{ '/cv/ArindamCV_for_website.pdf' | relative_url }}"
        target="_blank"
        rel="noopener"
      >
        Open CV (PDF)
      </a>
    </p>

    <iframe
      class="cv-pdf"
      src="{{ '/cv/ArindamCV_for_website.pdf' | relative_url }}"
      title="Arindam Raj — Curriculum Vitae"
    ></iframe>

  </div>
</div>

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
