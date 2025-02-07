<template>
  <section class="links mb-4">
    <h2 v-if="title">{{ title }}</h2>
    <template v-if="hasGroups">
      <div class="group" v-for="group in groups" :key="group.rel">
        <h4 v-if="group.rel">{{ group.label }}</h4>
        <ul>
          <li v-for="(link, key) in group.links" :key="key">
            <StacLink :data="link" :fallbackTitle="() => fallbackTitle(link)" />
          </li>
        </ul>
      </div>
    </template>
    <ul v-else>
      <li v-for="(link, key) in links" :key="key">
        <StacLink :data="link" :fallbackTitle="() => fallbackTitle(link)" />
      </li>
    </ul>
  </section>
</template>

<script>
import StacLink from './StacLink.vue';
import Fields from '@radiantearth/stac-fields/fields.json';
import Utils from '../utils';
import { formatKey } from '@radiantearth/stac-fields/helper';

const OGC_REL_PREFIX = 'http://www.opengis.net/def/rel/ogc/1.0/';

export default {
  name: "Links",
  components: {
    StacLink
  },
  props: {
    title: {
      type: String,
      default: null
    },
    links: {
      type: Array,
      default: () => ([])
    }
  },
  computed: {
    groups() {
      let groups = this.links.reduce((summary, link) => {
        let rel = typeof link.rel === 'string' ? link.rel.toLowerCase() : "";
        if (rel in summary) {
          summary[rel].links.push(link);
        }
        else {
          summary[rel] = {
            rel: rel,
            label: this.formatRel(rel),
            links: [link]
          };
        }
        return summary;
      }, {});
      return Object.values(groups).sort((g1, g2) => g1.rel.localeCompare(g2.rel));
    },
    hasGroups() {
      return this.groups.some(group => group.rel.length > 0 && group.links.length >= 2);
    }
  },
  methods: {
    formatRel(rel) {
      let lc = typeof rel === 'string' ? rel.toLowerCase() : "";
      if (lc in Fields.links.rel.mapping) {
        return Fields.links.rel.mapping[lc];
      }
      else {
        if (rel.startsWith(OGC_REL_PREFIX)) {
          rel = rel.substr(OGC_REL_PREFIX.length);
        }
        return formatKey(rel);
      }
    },
    fallbackTitle(link) {
      let title = Utils.titleForHref(link.href);
      if (this.hasGroups) {
        return title;
      }
      else {
        let rel = this.formatRel(link.rel);
        return `${rel}: ${title}`;
      }
    }
  }
};
</script>

<style lang="scss">
#stac-browser .links {
  ul {
    list-style-type: '-';
    margin: 0 0 1em 1em;
    padding: 0;

    > li {
      margin-bottom: 0.2em;
      padding-left: 0.5em;
    }
  }
}
</style>