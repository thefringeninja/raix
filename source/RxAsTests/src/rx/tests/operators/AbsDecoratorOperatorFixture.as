package rx.tests.operators
{
	import org.flexunit.Assert;
	
	import rx.IObservable;
	import rx.ICancelable;
	import rx.Subject;
	import rx.tests.mocks.StatsObserver;
	
	// Includes common tests for all decorator operators
	public class AbsDecoratorOperatorFixture
	{
		public function AbsDecoratorOperatorFixture()
		{
		}
		
		[Test]
		public function unsubscribes_from_source_on_completed() : void
		{
			var manObs : Subject = new Subject(int);
			
			var index : int = 0;
			
			var obs : IObservable = createEmptyObservable(manObs);
			
			var stats : StatsObserver = new StatsObserver();
			
			obs.subscribe(stats);
			
			manObs.onCompleted();
			
			Assert.assertFalse(manObs.hasSubscriptions);
		}
		
		[Test]
		public function unsubscribes_from_source_on_error() : void
		{
			var manObs : Subject = new Subject(int);
			
			var index : int = 0;
			
			var obs : IObservable = createEmptyObservable(manObs);
			
			var stats : StatsObserver = new StatsObserver();
			
			obs.subscribe(stats);
			
			manObs.onError(new Error());
			
			Assert.assertFalse(manObs.hasSubscriptions);
		}
		
		[Test]
		public function unsubscribes_from_source_on_unsubscribe() : void
		{
			var manObs : Subject = new Subject(int);
			
			var index : int = 0;
			
			var obs : IObservable = createEmptyObservable(manObs);
			
			var stats : StatsObserver = new StatsObserver();
			
			var subs : ICancelable = obs.subscribe(stats);
			
			subs.cancel();
			
			Assert.assertFalse(manObs.hasSubscriptions);
		}
		
		[Test]
		public function is_normalized_for_oncompleted() : void
		{
			var manObs : Subject = new Subject(int);
			
			var index : int = 0;
			
			var obs : IObservable = createEmptyObservable(manObs);
			
			var stats : StatsObserver = new StatsObserver();
			
			var subs : ICancelable = obs.subscribe(stats);
			
			manObs.onCompleted();
			manObs.onNext(new Object());
			manObs.onError(new Error());
			
			Assert.assertFalse(stats.nextCalled);
			Assert.assertFalse(stats.errorCalled);
		}
		
		[Test]
		public function is_normalized_for_onerror() : void
		{
			var manObs : Subject = new Subject(int);
			
			var index : int = 0;
			
			var obs : IObservable = createEmptyObservable(manObs);
			
			var stats : StatsObserver = new StatsObserver();
			
			var subs : ICancelable = obs.subscribe(stats);
			
			manObs.onError(new Error());
			manObs.onNext(new Object());
			manObs.onCompleted();
			
			Assert.assertFalse(stats.nextCalled);
			Assert.assertFalse(stats.completedCalled);
		}
		
		protected function createEmptyObservable(source : IObservable) : IObservable
		{
			Assert.fail("createEmptyObservable must be overriden");
			
			return null;
		}
	}
}