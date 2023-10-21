import { PureComponent } from 'react';

import { Switch, Route, withRouter } from 'react-router-dom';

import AccountNavigation from 'mastodon/features/account/navigation';
import Trends from 'mastodon/features/getting_started/containers/trends_container';
import { showTrends, mascot } from 'mastodon/initial_state';

import elephantUIPlane from 'images/elephant_ui_plane.svg';

const DefaultNavigation = () => (
  <>
    <div className='drawer__inner__mastodon navigation_icon'>
      <img alt='' draggable='false' src={mascot || elephantUIPlane} />
    </div>
    {
      showTrends ? (
        <Trends />
      ) : null
    }
  <>
);

class NavigationPortal extends PureComponent {

  render () {
    return (
      <Switch>
        <Route path='/@:acct' exact component={AccountNavigation} />
        <Route path='/@:acct/tagged/:tagged?' exact component={AccountNavigation} />
        <Route path='/@:acct/with_replies' exact component={AccountNavigation} />
        <Route path='/@:acct/followers' exact component={AccountNavigation} />
        <Route path='/@:acct/following' exact component={AccountNavigation} />
        <Route path='/@:acct/media' exact component={AccountNavigation} />
        <Route component={DefaultNavigation} />
      </Switch>
    );
  }

}
export default withRouter(NavigationPortal);
