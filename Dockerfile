FROM eoluchile/edx-platform:5ceef28c65571d2bcf41572fa50840fd65c1f626 as base

# Install private requirements: this is useful for installing custom xblocks.
# In particular, to install xblocks from a private repository, clone the
# repositories to ./requirements on the host and add `-e ./myxblock/` to
# ./requirements/private.txt.
COPY ./requirements/ /openedx/requirements
RUN touch /openedx/requirements/private.txt \
    && pip install --src ../venv/src -r /openedx/requirements/private.txt

# Copy themes
COPY ./themes/ /openedx/themes/
RUN openedx-assets themes \
    && openedx-assets collect --settings=prod.assets

FROM rclone/rclone:1.53 as s3

COPY --from=base /openedx/staticfiles /data
