<template>
  <b-card no-body class="item-card" :class="{queued: !data, deprecated: isDeprecated}" v-b-visible.200="load">
    <b-card-img
      v-if="thumbnail && thumbnailShown" class="thumbnail"
      :src="thumbnail.href" :alt="thumbnail.title" :crossorigin="crossOriginMedia"
      @error="hideBrokenImg"
    />
    <b-card-body>
      <b-card-title>
        <StacLink :data="[data, item]" class="stretched-link" />
      </b-card-title>
      <b-card-text>
        <small class="text-muted">
          <template v-if="extent">{{ extent | formatTemporalExtent }}</template>
          <template v-else-if="data && data.properties.datetime">{{ data.properties.datetime | formatTimestamp }}</template>
          <template v-else>No time given</template>
        </small>
      </b-card-text>
      <b-card-text v-if="fileFormats.length > 0 || isDeprecated">
        <b-badge v-for="format in fileFormats" :key="format" variant="secondary" class="mr-1 mt-1 fileformat">{{ format | formatMediaType }}</b-badge>
        <b-badge v-if="isDeprecated" variant="warning" class="mr-1 mt-1 deprecated">Deprecated</b-badge>
      </b-card-text>
    </b-card-body>
  </b-card>
</template>

<script>
import { mapGetters, mapState } from 'vuex';
import StacLink from './StacLink.vue';
import STAC from '../models/stac';
import { formatTemporalExtent, formatTimestamp, formatMediaType } from '@radiantearth/stac-fields/formatters';

export default {
  name: 'Item',
  components: {
    StacLink
  },
  filters: {
    formatMediaType,
    formatTemporalExtent,
    formatTimestamp
  },
  props: {
    item: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      // Lazy load thumbnails and not all at once.
      // false = don't load yet, true = try to load it, null = image errored
      thumbnailShown: false
    };
  },
  computed: {
    ...mapState(['crossOriginMedia']),
    ...mapGetters(['getStac']),
    data() {
      return this.getStac(this.item);
    },
    thumbnail() {
      if (this.data) {
        let thumbnails = this.data.getThumbnails(true, 'thumbnail');
        if (thumbnails.length > 0) {
          return thumbnails[0];
        }
      }
      return {
        href: null,
        title: ''
      };
    },
    extent() {
      if (this.data && (this.data.properties.start_datetime || this.data.properties.end_datetime)) {
        return [this.data.properties.start_datetime, this.data.properties.end_datetime];
      }
      return null;
    },
    fileFormats() {
      if (!this.data) {
        return [];
      }
      return Object.values(this.data.assets)
        .filter(asset => Array.isArray(asset.roles) && asset.roles.includes('data') && typeof asset.type === 'string') // Look for data files
        .map(asset => asset.type) // Array shall only contain media types
        .filter((v, i, a) => a.indexOf(v) === i); // Unique values
    },
    isDeprecated() {
      return this.data instanceof STAC && Boolean(this.data.properties.deprecated);
    }
  },
  methods: {
    hideBrokenImg(event) {
      console.log(`Hiding item thumbnail for ${event.srcElement.src} as it can't be loaded.`);
      this.thumbnailShown = null;
    },
    load(visible) {
      if (visible && this.thumbnailShown !== null) {
        this.thumbnailShown = true;
      }
      if (this.item instanceof STAC) {
        return;
      }
      this.$store.commit(visible ? 'queue' : 'unqueue', this.item.href);
    }
  }
};
</script>

<style lang="scss">
#stac-browser {
  .item-card {
    text-align: center;

    &.deprecated {
      opacity: 0.7;

      &:hover {
        opacity: 1;
      }
    }

    &.queued {
      min-height: 200px;
    }

    .badge {
      overflow: hidden;
      text-overflow: ellipsis;
      max-width: 100%;

      &.deprecated {
        text-transform: uppercase;
      }
    }

    .card-img {
      width: auto;
      height: auto;
      max-width: 100%;
      max-height: 200px;
    }
    .card-body {
      text-align: center;
    }
  }
}
</style>