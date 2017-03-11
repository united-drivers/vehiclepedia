---
layout: listing
title: Cars
---
<ul>
  {% for page in site.pages %}
    {% if page.layout != "car" %}{% continue %}{% endif %}
    <li><a href="{{ page.url }}">{{page.brand}} - {{ page.title }}</a></li>
  {% endfor %}
</ul>
