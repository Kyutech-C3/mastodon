import React from 'react';
import { Switch, Route, withRouter } from 'react-router-dom';
import { showTrends, mascot } from 'mastodon/initial_state';
import Trends from 'mastodon/features/getting_started/containers/trends_container';
import AccountNavigation from 'mastodon/features/account/navigation';
import elephantUIPlane from 'images/elephant_ui_plane.svg';

const DefaultNavigation = () => (
  <>
    <div className='drawer__inner__mastodon navigation_icon'>
      <img alt='' draggable='false' src={mascot || elephantUIPlane} />
    </div>
    {showTrends && (
      <Trends />
    )}
  </>
);

export default @withRouter
class NavigationPortal extends React.PureComponent {

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
