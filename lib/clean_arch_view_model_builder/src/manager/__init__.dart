// ignore: use_string_in_part_of_directives
part of clean_arch_view_model_builder;

class CleanArchBuilder<T extends CleanArchBaseController,
    S extends CleanArchBaseService> extends StatelessWidget {
  const CleanArchBuilder({
    super.key,
    this.reactive = true,
    required this.viewModelBuilder,
    required this.builder,
    this.onViewModelReady,
    this.onDispose,
    this.disposeViewModel = true,
    this.createNewViewModelOnInsert = false,
    this.fireOnViewModelReadyOnce = false,
    this.initialiseSpecialViewModelsOnce = false,
    this.staticChild,
    required this.serviceBuilder,
    this.initialiseService = true,
    this.onServiceReady,
  });
  final bool reactive;
  final T Function() viewModelBuilder;
  final Widget Function(BuildContext context, T controller, S service) builder;
  final Function(T viewModel)? onViewModelReady;
  final Function(S service)? onServiceReady;
  final Function(T viewModel)? onDispose;
  final bool disposeViewModel;
  final bool createNewViewModelOnInsert;
  final bool fireOnViewModelReadyOnce;
  final bool initialiseSpecialViewModelsOnce;
  final Widget? staticChild;
  final S Function() serviceBuilder;
  final bool initialiseService;
  @override
  Widget build(BuildContext context) {
    if (reactive) {
      return ViewModelBuilder.reactive(
        viewModelBuilder: viewModelBuilder,
        builder: (context, controller, child) {
          return builder(
            context,
            controller,
            serviceBuilder(),
          );
        },
        onViewModelReady: (viewModel) {
          CleanArchInjector.init<T>(
            viewModelBuilder(),
          );
          CleanArchInjector.init<S>(
            serviceBuilder(),
          );
          if (onViewModelReady != null) {
            onViewModelReady!(viewModel);
          }
          if (onServiceReady != null) {
            onServiceReady!(
              serviceBuilder(),
            );
          }
        },
        onDispose: (viewModel) {
          if (onDispose != null) {
            onDispose!(viewModel);
          }
          CleanArchInjector.dispose<T>();
          CleanArchInjector.dispose<S>();
        },
        disposeViewModel: disposeViewModel,
        createNewViewModelOnInsert: createNewViewModelOnInsert,
        fireOnViewModelReadyOnce: fireOnViewModelReadyOnce,
        initialiseSpecialViewModelsOnce: initialiseSpecialViewModelsOnce,
        staticChild: staticChild,
      );
    } else {
      return ViewModelBuilder.nonReactive(
        viewModelBuilder: viewModelBuilder,
           builder: (context, controller, child) {
          return builder(
            context,
            controller,
            serviceBuilder(),
          );
        },
        onViewModelReady: (viewModel) {
          if (onViewModelReady != null) {
            onViewModelReady!(viewModel);
          }
          CleanArchInjector.init<T>(
            viewModelBuilder(),
          );
          CleanArchInjector.init<CleanArchBaseService>(
            serviceBuilder(),
          );
        },
        onDispose: (viewModel) {
          if (onDispose != null) {
            onDispose!(viewModel);
          }
          CleanArchInjector.dispose<T>();
          CleanArchInjector.dispose<CleanArchBaseService>();
        },
        disposeViewModel: disposeViewModel,
        createNewViewModelOnInsert: createNewViewModelOnInsert,
        fireOnViewModelReadyOnce: fireOnViewModelReadyOnce,
        initialiseSpecialViewModelsOnce: initialiseSpecialViewModelsOnce,
      );
    }
  }
}
