import React from 'react';
import PropTypes from 'prop-types';
import { injectIntl } from 'react-intl';
import ImmutablePureComponent from 'react-immutable-pure-component';

const classTimeTable = [
  // class start and end minutes from 00:00
  // 1
  {
    start: 8 * 60 + 50,
    end: 10 * 60 + 20,
  },
  // 2
  {
    start: 10 * 60 + 30,
    end: 12 * 60,
  },
  // 3
  {
    start: 13 * 60,
    end: 14 * 60 + 30,
  },
  // 4
  {
    start: 14 * 60 + 40,
    end: 16 * 60 + 10,
  },
  // 5
  {
    start: 16 * 60 + 20,
    end: 17 * 60 + 50,
  },
];

export default @injectIntl
class KitStatus extends ImmutablePureComponent {

  constructor(props) {
    super(props);

    // 現在何コマ目か
    this.nowClass = null;

    // 現在平日か
    this.isWeekday = false;

  }

  static contextTypes = {
    router: PropTypes.object,
  };

  checkIsWeekday() {
    const day = new Date().getDay();
    console.debug('day', day);
    return day % 6 === 0 ? false : true;
  }

  getNowClass() {
    const now = new Date();
    const nowMinutes = now.getHours() * 60 + now.getMinutes();
    console.debug('nowMinutes', nowMinutes);
    return classTimeTable.findIndex((timeTable) => {
      return (timeTable.start < nowMinutes && timeTable.end > nowMinutes) ? true : false;
    });
  }

  componentWillMount () {
    this.isWeekday = this.checkIsWeekday();
    this.nowClass = this.getNowClass();
  }

  classStatus() {
    console.debug('isWeekday', this.isWeekday, 'nowClass', this.nowClass);
    if (this.isWeekday) {
      if (this.nowClass === -1) {
        return <>今日は<span className='compose-form__kit-status__accent'>平日</span>です。</>;
      } else {
        return <>現在は<span className='compose-form__kit-status__accent'>{this.nowClass + 1}コマ目</span>です。</>;
      }
    } else {
      return <>今日は<span className='compose-form__kit-status__accent'>休日</span>です。</>;
    }
  }

  render () {
    return (
      <div className='compose-form__kit-status__inner'>
        { this.classStatus() }
      </div>
    );
  }

}
