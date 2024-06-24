import React from 'react';
import PropTypes from 'prop-types';
import ImmutablePureComponent from 'react-immutable-pure-component';
import { defineMessages, injectIntl } from 'react-intl';

const messages = defineMessages({
  cautionMessage: { id: 'custom.caution_message', defaultMessage: 'CAUTION' },
});

class LiteracyCaution extends ImmutablePureComponent {
  static propTypes = {
    intl: PropTypes.object.isRequired,
  }

  render() {
    const { intl } = this.props;
    return (
      <div className="literacy-caution">
        <a href="https://onlineguide.isc.kyutech.ac.jp/guide2020/index.php/home/2020-02-04-02-50-29/2020-03-03-01-40-44">
          <p>
            { intl.formatMessage(messages.cautionMessage) }
          </p>
        </a>
      </div>
    )
  }
}

export default injectIntl(LiteracyCaution);
