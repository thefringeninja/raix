package raix.reactive.tests.operators.filter
{
	import org.flexunit.Assert;
	
	import raix.reactive.IObservable;
	import raix.reactive.Observable;
	import raix.reactive.Subject;
	import raix.reactive.tests.mocks.StatsObserver;
	import raix.reactive.tests.operators.AbsDecoratorOperatorFixture;
	
	[TestCase]
	public class TakeUntilFixture extends AbsDecoratorOperatorFixture
	{
		protected override function createEmptyObservable(source:IObservable):IObservable
		{
			return source.takeUntil(Observable.never());
		}
		
		[Test]
		public function values_are_returned_until_other_observer_raises_value() : void
		{
			var primaryObs : Subject = new Subject();
			var otherObs : Subject = new Subject();
			
			var obs : IObservable = primaryObs.takeUntil(otherObs);
			
			var stats : StatsObserver = new StatsObserver();
			
			obs.subscribeWith(stats);
			
			primaryObs.onNext(0);
			primaryObs.onNext(1);
			primaryObs.onNext(2);
			otherObs.onNext(0);
			primaryObs.onNext(3);
			
			Assert.assertEquals(3, stats.nextCount);
			Assert.assertEquals(0, stats.nextValues[0]);
			Assert.assertEquals(1, stats.nextValues[1]);
			Assert.assertEquals(2, stats.nextValues[2]);
			Assert.assertTrue(stats.completedCalled);
		}
		
		[Test]
		public function values_are_returned_until_other_observer_completes() : void
		{
			var primaryObs : Subject = new Subject();
			var otherObs : Subject = new Subject();
			
			var obs : IObservable = primaryObs.takeUntil(otherObs);
			
			var stats : StatsObserver = new StatsObserver();
			
			obs.subscribeWith(stats);
			
			primaryObs.onNext(0);
			primaryObs.onNext(1);
			primaryObs.onNext(2);
			otherObs.onCompleted();
			primaryObs.onNext(3);
			
			Assert.assertEquals(3, stats.nextCount);
			Assert.assertEquals(0, stats.nextValues[0]);
			Assert.assertEquals(1, stats.nextValues[1]);
			Assert.assertEquals(2, stats.nextValues[2]);
			Assert.assertTrue(stats.completedCalled);
		}
		
		[Test]
		public function values_are_returned_until_other_observer_raises_error() : void
		{
			var primaryObs : Subject = new Subject();
			var otherObs : Subject = new Subject();
			
			var obs : IObservable = primaryObs.takeUntil(otherObs);
			
			var stats : StatsObserver = new StatsObserver();
			
			obs.subscribeWith(stats);
			
			primaryObs.onNext(0);
			primaryObs.onNext(1);
			primaryObs.onNext(2);
			otherObs.onError(new Error());
			primaryObs.onNext(3);
			
			Assert.assertEquals(3, stats.nextCount);
			Assert.assertEquals(0, stats.nextValues[0]);
			Assert.assertEquals(1, stats.nextValues[1]);
			Assert.assertEquals(2, stats.nextValues[2]);
			Assert.assertTrue(stats.errorCalled);
			
		}
		
		[Test(expects="Error")]
		public function errors_thrown_by_subscriber_are_bubbled() : void
		{
			var manObs : Subject = new Subject();
			
			var obs : IObservable = manObs.takeUntil(Observable.never());
			
			obs.subscribe(
				function(pl:int):void { throw new Error(); },
				function():void { },
				function(e:Error):void { Assert.fail("Unexpected call to onError"); }
			);

			manObs.onNext(0);
		}
	}
}